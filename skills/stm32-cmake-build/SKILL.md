---
name: stm32-cmake-build
description: 用于 STM32 固件工程的 CMake 或 CMakePresets 检查、配置、编译与产物确认。Use this skill for STM32 firmware projects that need CMake preset inspection, configure/build loops, and artifact validation on Windows PowerShell.
---

# STM32 CMake 构建

当任务重点在构建侧，而不是烧录或串口观测时，使用这个 skill。它负责识别正确的 preset、执行 configure/build、确认产物路径，并保持构建链路稳定。

## 适用场景

- STM32 工程包含 `CMakeLists.txt`
- 工程已经使用 `CMakePresets.json`
- 需要确认或选择 `Debug`、`Release` 等 preset
- 需要处理 configure 或 compile 错误
- 需要确认 `.elf`、`.bin`、`.map` 等构建产物

## 工作流程

1. 先检查工程结构。
   重点看 `CMakePresets.json`、`CMakeLists.txt`、现有 `build/` 目录、工具链文件和工程说明。

2. 复用工程已有构建方式。
   优先使用工程定义的 preset，不随意新建 build 目录或切换 generator。

3. 先 configure，再 build。
   在 Windows PowerShell 下优先使用：
   - `cmake --preset <name>`
   - `cmake --build --preset <name>`

4. 明确确认产物路径。
   不假设 `.elf` 的位置，必须以实际构建结果为准，为后续烧录提供准确输入。

5. 把 configure 错误和 compile 错误分开处理。
   configure 失败先看 preset、generator、toolchain 和环境；compile 失败再看源码、头文件、宏定义和生成文件。

## 操作规则

- 默认假设环境是 Windows + PowerShell。
- 一步一个命令，避免把多个动作揉在一起。
- 没有充分理由时，不要在调试中途切换 preset。
- 没有充分证据时，不要替换工具链。
- 只要用户反馈“代码改了但板子没变”，先确认目标二进制是否真的重新构建出来了。

## 判断优先级

- 如果代码改动没有体现在目标设备上，先怀疑 preset 错、artifact 错，再怀疑烧录或运行时逻辑。
- 如果存在多个 build 目录，必须先确认当前工程实际用的是哪一个。
- 如果产物路径不清楚，优先查 preset 和 target 输出，而不是猜路径。

## 参考资料

- 需要具体命令模板和产物检查顺序时，读 [references/playbook.md](references/playbook.md)。
