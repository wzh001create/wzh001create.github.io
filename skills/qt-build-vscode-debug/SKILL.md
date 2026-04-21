---
name: qt-build-vscode-debug
description: "用于 Windows 上的 Qt/C++ 项目构建、环境排错、qmake/CMake 识别、MinGW/Qt 路径修复、VSCode tasks.json 和 launch.json 生成、编译后在 VSCode 中打开并进入调试。适用于需要处理 Qt 构建失败、PATH 污染、uic/moc/rcc 缺失、g++/cc1plus 不可用、区分 qmake 与 CMake、为现有 Qt 项目补齐 VSCode 调试配置的场景。Keywords: Qt, qmake, CMake, MinGW, MSVC, VSCode, launch.json, tasks.json, debug, build."
---
# Qt Build Vscode Debug

## 概述

用于处理 Windows 上 Qt 项目的构建、环境问题定位，以及为 VSCode 补齐可直接调试的配置。优先复用项目现有构建体系，不随意改工程结构。

## 工作流程

### 1. 先识别工程类型

按下面顺序判断：

- 若存在 `CMakeLists.txt`，按 CMake 工程处理。
- 若存在 `.pro` 文件，按 qmake 工程处理。
- 若两者都存在，优先沿用项目当前已经在用的构建产物：
  - 已有 `build/`、`CMakeCache.txt`、`CMakePresets.json` 时优先 CMake。
  - 已有 `Makefile`、`qmake_stash`、`.pro.user` 且没有 CMake 构建目录时优先 qmake。
- 若无法判断，先读取顶层构建文件和现有产物，再决定，不要猜。

### 2. 先固定编译环境，再运行命令

Qt 项目在 Windows 上最常见的问题不是代码，而是环境不一致。处理时优先做这几件事：

- 明确工具链：`MinGW` 还是 `MSVC`。
- 明确 Qt 安装路径，例如：
  - `C:\Qt\Tools\mingw1310_64\bin`
  - `C:\Qt\6.11.0\mingw_64\bin`
- 运行编译命令时，显式把 Qt 和编译器路径前置到 `PATH`。
- PowerShell 下如发现 profile 污染 PATH，优先使用不加载 profile 的方式运行，或显式重建 `PATH`。

典型 MinGW 环境前置写法：

```powershell
$env:PATH='C:\Qt\Tools\mingw1310_64\bin;C:\Qt\6.11.0\mingw_64\bin;' + $env:PATH
```

若出现以下症状，优先怀疑环境问题：

- `g++: fatal error: cannot execute 'cc1plus'`
- 找不到 `uic` / `moc` / `rcc`
- Qt DLL 或 platform plugin 缺失
- 同一工程在 Qt Creator 能编、在命令行不能编

### 3. 构建策略

#### qmake 工程

优先顺序：

1. 如果工程目录已有可用 `Makefile`，直接编译。
2. 如果没有 `Makefile`，先运行 `qmake` 生成，再运行 `mingw32-make`。
3. 不要无理由删除已有 `Makefile`、`.pro.user` 或构建产物。

常见命令：

```powershell
& 'C:\Qt\Tools\mingw1310_64\bin\mingw32-make.exe' -j4
```

如果需要先生成 Makefile：

```powershell
& 'C:\Qt\6.11.0\mingw_64\bin\qmake.exe' project.pro
& 'C:\Qt\Tools\mingw1310_64\bin\mingw32-make.exe' -j4
```

#### CMake 工程

优先复用现有 `build` 目录、`CMakePresets.json` 或生成器设置。没有现成配置时，再手动配置。

常见流程：

```powershell
cmake -S . -B build -G "MinGW Makefiles" -DCMAKE_PREFIX_PATH="C:/Qt/6.11.0/mingw_64"
cmake --build build -j4
```

如果项目已经有现成 `build/Debug` 或 `build/Release`，优先直接：

```powershell
cmake --build build\Debug -j4
```

### 4. 失败时怎么定位

按以下顺序检查：

1. **先看是不是环境问题**
   - 编译器路径是否来自预期 Qt/MinGW。
   - `qmake`、`uic`、`moc`、`mingw32-make` 是否同一套 Qt。

2. **再看是不是工程类型判断错了**
   - 不要拿 qmake 工程去跑 CMake，也不要反过来。

3. **最后再看代码错误**
   - 若是代码编译错误，按正常 C++/Qt 方式处理。
   - 若只是 warning，不要误判为构建失败。

### 5. VSCode 调试配置

构建通过后，如项目缺少 `.vscode/tasks.json` 和 `.vscode/launch.json`，补齐最小可用配置。

处理原则：

- 若已有 `.vscode` 配置，优先增量修改，不重写。
- `launch.json` 里的 `program` 必须指向实际产物。
- `cwd` 设为程序工作目录，通常是工程根目录或产物目录。
- `PATH` 中需要包含 Qt bin 和编译器 bin，避免运行时找不到 Qt DLL。
- 如果构建任务已存在，`preLaunchTask` 直接复用；没有再新增。

qmake + MinGW 常见 `launch.json` 关键字段：

```json
{
  "type": "cppdbg",
  "request": "launch",
  "name": "Debug Qt App",
  "program": "${workspaceFolder}/debug/teststq.exe",
  "cwd": "${workspaceFolder}",
  "MIMode": "gdb",
  "miDebuggerPath": "C:/Qt/Tools/mingw1310_64/bin/gdb.exe",
  "preLaunchTask": "Build Qt Project",
  "environment": [
    {
      "name": "PATH",
      "value": "C:/Qt/6.11.0/mingw_64/bin;C:/Qt/Tools/mingw1310_64/bin;${env:PATH}"
    }
  ]
}
```

对应 `tasks.json` 常见字段：

```json
{
  "label": "Build Qt Project",
  "type": "shell",
  "command": "C:/Qt/Tools/mingw1310_64/bin/mingw32-make.exe",
  "args": ["-j4"],
  "options": {
    "cwd": "${workspaceFolder}"
  },
  "problemMatcher": ["$gcc"]
}
```

如果项目是 CMake，并且已经依赖 VSCode CMake Tools，则优先复用 CMake Tools 现有调试链路，而不是重复造一套。

### 6. 编译后在 VSCode 中打开

当用户明确要求在 VSCode 中打开项目或进入调试时：

- 先确认编译产物存在。
- 再确认 `.vscode/launch.json` 和 `.vscode/tasks.json` 已经可用。
- 然后使用 `code -r <project>` 打开工作区，或按用户要求打开指定目录。
- 如果 `code` 命令不可用，明确说明，并提示用户从 VSCode 安装命令行入口，或改为只生成配置文件。

### 7. 输出要求

完成这类任务时，至少输出：

- 工程类型判断结果（qmake / CMake）
- 实际使用的 Qt 路径和编译器路径
- 构建命令
- 产物路径
- 若补齐了 VSCode 配置，说明改了哪些文件
- 若构建失败，明确是环境问题还是代码问题

## 默认做法

- 默认优先保证“能稳定编译 + 能稳定调试”，而不是最少改动。
- 默认保留用户现有工程结构和构建方式。
- 默认优先修环境，再修工程，再修代码。
- 默认在完成编译后，若用户要求，补齐 VSCode 调试配置并打开工作区。

