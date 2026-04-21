import { promises as fs } from "node:fs";
import path from "node:path";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const rootDir = process.cwd();
const sourceDir = path.join(rootDir, "skills");
const contentDir = path.join(rootDir, "content", "skills");
const staticSkillDir = path.join(rootDir, "static", "skill-files");
const apiDir = path.join(rootDir, "static", "api", "skills");
const apiIndexFile = path.join(rootDir, "static", "api", "skills.json");
const execFileAsync = promisify(execFile);

const SKIPPED_SOURCE_NAMES = new Set(["README.md"]);

async function main() {
  await fs.mkdir(sourceDir, { recursive: true });
  await fs.mkdir(contentDir, { recursive: true });
  await cleanGeneratedMarkdown();
  await cleanDir(staticSkillDir);
  await cleanDir(apiDir);

  const skills = await collectSkills();
  await Promise.all(skills.map((skill) => writeSkillArtifacts(skill)));
  await fs.mkdir(path.dirname(apiIndexFile), { recursive: true });
  await fs.writeFile(apiIndexFile, `${JSON.stringify(skills, null, 2)}\n`, "utf8");

  console.log(`Generated ${skills.length} skill page(s).`);
}

async function collectSkills() {
  const entries = await fs.readdir(sourceDir, { withFileTypes: true });
  const skills = [];

  for (const entry of entries) {
    if (!entry.isDirectory()) {
      continue;
    }

    if (entry.name.startsWith("_") || entry.name.startsWith(".") || SKIPPED_SOURCE_NAMES.has(entry.name)) {
      continue;
    }

    const skillRoot = path.join(sourceDir, entry.name);
    const skillDocPath = path.join(skillRoot, "SKILL.md");

    try {
      await fs.access(skillDocPath);
    } catch {
      continue;
    }

    const markdown = await fs.readFile(skillDocPath, "utf8");
    const { frontmatter, body: markdownBody } = splitFrontmatter(markdown);
    const metadata = await readMetadata(path.join(skillRoot, "skill.json"));
    const stat = await fs.stat(skillDocPath);

    const title =
      metadata.name ||
      extractTitle(markdownBody) ||
      frontmatter.title ||
      frontmatter.name ||
      humanize(entry.name);
    const slug = metadata.slug || slugify(entry.name);
    const summary =
      metadata.summary ||
      extractSummary(markdownBody) ||
      frontmatter.description ||
      `${title} 的技能说明。`;
    const description = metadata.description || frontmatter.description || summary;
    const lastmod = metadata.updatedAt || stat.mtime.toISOString();
    const body = rewriteRelativeReferences(markdownBody, `/skill-files/${slug}`);
    const tags = normalizeStringArray(metadata.tags);
    const platforms = normalizeStringArray(metadata.platforms);
    const installCommands = normalizeStringArray(metadata.install);
    const weight = Number.isFinite(metadata.order) ? metadata.order : 1000;

    skills.push({
      title,
      slug,
      summary,
      description,
      author: metadata.author || "",
      version: metadata.version || "",
      tags,
      platforms,
      install_commands: installCommands,
      homepage_url: metadata.homepage || "",
      repo_url: metadata.repo || "",
      download_url: `/skill-files/${slug}.zip`,
      page_url: `/skills/${slug}/`,
      source_dir: `skills/${entry.name}`,
      featured: Boolean(metadata.featured),
      weight,
      lastmod,
      body,
      source_entry_name: entry.name,
    });
  }

  return skills.sort((left, right) => {
    if (left.weight !== right.weight) {
      return left.weight - right.weight;
    }
    return left.title.localeCompare(right.title, "zh-Hans-CN");
  });
}

async function writeSkillArtifacts(skill) {
  const sourceRoot = path.join(sourceDir, skill.source_entry_name);
  const staticRoot = path.join(staticSkillDir, skill.slug);
  const archiveFile = path.join(staticSkillDir, `${skill.slug}.zip`);
  const contentFile = path.join(contentDir, `${skill.slug}.md`);
  const apiFile = path.join(apiDir, `${skill.slug}.json`);

  await copyDirectory(sourceRoot, staticRoot);
  await createZipArchive(sourceRoot, archiveFile, skill.source_entry_name);
  await fs.mkdir(path.dirname(contentFile), { recursive: true });
  await fs.writeFile(contentFile, buildMarkdownPage(skill), "utf8");
  await fs.writeFile(apiFile, `${JSON.stringify(publicSkillPayload(skill), null, 2)}\n`, "utf8");
}

async function readMetadata(filePath) {
  try {
    const raw = await fs.readFile(filePath, "utf8");
    return JSON.parse(raw);
  } catch {
    return {};
  }
}

async function cleanGeneratedMarkdown() {
  try {
    const entries = await fs.readdir(contentDir, { withFileTypes: true });
    for (const entry of entries) {
      if (entry.name === "_index.md") {
        continue;
      }

      await fs.rm(path.join(contentDir, entry.name), { recursive: true, force: true });
    }
  } catch {
    await fs.mkdir(contentDir, { recursive: true });
  }
}

async function cleanDir(dirPath) {
  await fs.rm(dirPath, { recursive: true, force: true });
  await fs.mkdir(dirPath, { recursive: true });
}

async function copyDirectory(source, target) {
  await fs.mkdir(target, { recursive: true });
  const entries = await fs.readdir(source, { withFileTypes: true });

  for (const entry of entries) {
    if (entry.name.startsWith(".DS_Store")) {
      continue;
    }

    const sourcePath = path.join(source, entry.name);
    const targetPath = path.join(target, entry.name);

    if (entry.isDirectory()) {
      await copyDirectory(sourcePath, targetPath);
      continue;
    }

    await fs.copyFile(sourcePath, targetPath);
  }
}

async function createZipArchive(sourceRoot, targetFile, folderName) {
  await fs.mkdir(path.dirname(targetFile), { recursive: true });
  await fs.rm(targetFile, { force: true });

  if (process.platform === "win32") {
    const command = [
      "$ErrorActionPreference = 'Stop'",
      `$source = ${toPowerShellLiteral(sourceRoot)}`,
      `$target = ${toPowerShellLiteral(targetFile)}`,
      "Compress-Archive -LiteralPath $source -DestinationPath $target -CompressionLevel Optimal -Force",
    ].join("; ");

    await execFileAsync("powershell.exe", ["-NoProfile", "-Command", command], { cwd: rootDir });
    return;
  }

  const script = [
    "import os, sys, zipfile",
    "source, target, folder = sys.argv[1:4]",
    "with zipfile.ZipFile(target, 'w', compression=zipfile.ZIP_DEFLATED) as zf:",
    "    for root, _, files in os.walk(source):",
    "        files.sort()",
    "        for name in files:",
    "            full_path = os.path.join(root, name)",
    "            rel_path = os.path.relpath(full_path, source).replace(os.sep, '/')",
    "            zf.write(full_path, f'{folder}/{rel_path}')",
  ].join("\n");

  await execFileAsync("python3", ["-c", script, sourceRoot, targetFile, folderName], { cwd: rootDir });
}

function buildMarkdownPage(skill) {
  const frontMatter = [
    "---",
    `title: ${quote(skill.title)}`,
    `description: ${quote(skill.description)}`,
    `summary: ${quote(skill.summary)}`,
    `slug: ${quote(skill.slug)}`,
    `date: ${quote(skill.lastmod)}`,
    `lastmod: ${quote(skill.lastmod)}`,
    "draft: false",
    "showtoc: true",
    `weight: ${skill.weight}`,
    `featured: ${skill.featured ? "true" : "false"}`,
    yamlArray("tags", skill.tags),
    yamlArray("platforms", skill.platforms),
    yamlArray("install_commands", skill.install_commands),
    `version: ${quote(skill.version)}`,
    `author: ${quote(skill.author)}`,
    `homepage_url: ${quote(skill.homepage_url)}`,
    `repo_url: ${quote(skill.repo_url)}`,
    `download_url: ${quote(skill.download_url)}`,
    `source_dir: ${quote(skill.source_dir)}`,
    "---",
  ]
    .join("\n");

  return `${frontMatter}\n\n${skill.body.trim()}\n`;
}

function publicSkillPayload(skill) {
  return {
    title: skill.title,
    slug: skill.slug,
    summary: skill.summary,
    description: skill.description,
    author: skill.author,
    version: skill.version,
    tags: skill.tags,
    platforms: skill.platforms,
    install: skill.install_commands,
    homepage_url: skill.homepage_url,
    repo_url: skill.repo_url,
    download_url: skill.download_url,
    page_url: skill.page_url,
    source_dir: skill.source_dir,
    featured: skill.featured,
    weight: skill.weight,
    lastmod: skill.lastmod,
  };
}

function extractTitle(markdown) {
  for (const line of markdown.split(/\r?\n/u)) {
    const match = line.match(/^#\s+(.+?)\s*$/u);
    if (match) {
      return match[1].trim();
    }
  }
  return "";
}

function extractSummary(markdown) {
  const lines = markdown.split(/\r?\n/u);
  let inFence = false;
  let collected = [];

  for (const rawLine of lines) {
    const line = rawLine.trim();

    if (line.startsWith("```") || line.startsWith("~~~")) {
      inFence = !inFence;
      continue;
    }

    if (inFence || !line) {
      if (collected.length > 0) {
        break;
      }
      continue;
    }

    if (/^(#|>|- |\* |\d+\. )/u.test(line)) {
      if (collected.length > 0) {
        break;
      }
      continue;
    }

    collected.push(line);
  }

  return stripMarkdown(collected.join(" "));
}

function stripMarkdown(value) {
  return value
    .replace(/`([^`]+)`/gu, "$1")
    .replace(/\[([^\]]+)\]\(([^)]+)\)/gu, "$1")
    .replace(/[*_~>#-]/gu, " ")
    .replace(/\s+/gu, " ")
    .trim();
}

function splitFrontmatter(markdown) {
  const normalized = markdown.replace(/^\uFEFF/gu, "").replace(/\r\n/gu, "\n");
  if (!normalized.startsWith("---\n")) {
    return { frontmatter: {}, body: markdown };
  }

  const endIndex = normalized.indexOf("\n---\n", 4);
  if (endIndex === -1) {
    return { frontmatter: {}, body: markdown };
  }

  const rawFrontmatter = normalized.slice(4, endIndex);
  const body = normalized.slice(endIndex + 5);
  return {
    frontmatter: parseSimpleYaml(rawFrontmatter),
    body,
  };
}

function parseSimpleYaml(rawFrontmatter) {
  const parsed = {};

  for (const rawLine of rawFrontmatter.split("\n")) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) {
      continue;
    }

    const match = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/u);
    if (!match) {
      continue;
    }

    const key = match[1];
    const value = stripYamlQuotes(match[2].trim());
    parsed[key] = value;
  }

  return parsed;
}

function stripYamlQuotes(value) {
  if (!value) {
    return "";
  }

  if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
    return value.slice(1, -1);
  }

  return value;
}

function rewriteRelativeReferences(markdown, baseUrl) {
  const lines = markdown.split(/\r?\n/u);
  let inFence = false;

  return lines
    .map((line) => {
      const trimmed = line.trim();
      if (trimmed.startsWith("```") || trimmed.startsWith("~~~")) {
        inFence = !inFence;
        return line;
      }

      if (inFence) {
        return line;
      }

      let nextLine = line.replace(/(!?\[[^\]]*?\]\()([^)\s]+)(\))/gu, (full, prefix, target, suffix) => {
        const rewritten = rewriteRelativeTarget(target, baseUrl);
        return rewritten ? `${prefix}${rewritten}${suffix}` : full;
      });

      nextLine = nextLine.replace(/\b(src|href)=["']([^"']+)["']/gu, (full, attr, target) => {
        const rewritten = rewriteRelativeTarget(target, baseUrl);
        return rewritten ? `${attr}="${rewritten}"` : full;
      });

      return nextLine;
    })
    .join("\n");
}

function rewriteRelativeTarget(target, baseUrl) {
  if (!target || isAbsoluteReference(target)) {
    return "";
  }

  const normalizedTarget = target.replace(/\\/gu, "/");
  const [pathPart, hashPart = ""] = normalizedTarget.split("#", 2);
  const [filePart, queryPart = ""] = pathPart.split("?", 2);
  const normalizedPath = path.posix.normalize(path.posix.join(baseUrl, filePart));

  if (!normalizedPath.startsWith(baseUrl)) {
    return "";
  }

  let rebuilt = normalizedPath;
  if (queryPart) {
    rebuilt += `?${queryPart}`;
  }
  if (hashPart) {
    rebuilt += `#${hashPart}`;
  }

  return rebuilt;
}

function isAbsoluteReference(value) {
  return /^(?:[a-z]+:|\/|#|data:|mailto:|tel:|javascript:)/iu.test(value);
}

function normalizeStringArray(value) {
  if (Array.isArray(value)) {
    return value.map((item) => String(item).trim()).filter(Boolean);
  }

  if (typeof value === "string" && value.trim()) {
    return [value.trim()];
  }

  return [];
}

function humanize(value) {
  return value
    .replace(/[-_]+/gu, " ")
    .replace(/\s+/gu, " ")
    .trim();
}

function slugify(value) {
  const normalized = value
    .normalize("NFKC")
    .trim()
    .toLowerCase()
    .replace(/[^\p{Letter}\p{Number}]+/gu, "-")
    .replace(/^-+|-+$/gu, "");

  return normalized || "skill";
}

function quote(value) {
  return JSON.stringify(value || "");
}

function yamlArray(key, values) {
  if (!values.length) {
    return `${key}: []`;
  }

  return `${key}:\n${values.map((value) => `  - ${quote(value)}`).join("\n")}`;
}

function toPowerShellLiteral(value) {
  return `'${String(value).replace(/'/gu, "''")}'`;
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
