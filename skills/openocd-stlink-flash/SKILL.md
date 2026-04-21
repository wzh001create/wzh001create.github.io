---
name: openocd-stlink-flash
description: 用于通过 OpenOCD 和 ST-Link 对 STM32 目标进行烧录、复位或基础调试。Use this skill for OpenOCD plus ST-Link flashing, reset handling, verified programming, and basic debug bring-up on STM32 targets.
---

# OpenOCD ST-Link 烧录

当任务重点在目标板烧录、复位或低层调试链路时，使用这个 skill。它只负责 OpenOCD 和 ST-Link 这一层，不负责构建和串口分析。

## 适用场景

- 使用 OpenOCD 烧录 STM32 固件
- 选择或确认 interface/target cfg 文件
- 执行 `program verify reset exit` 的正常烧录闭环
- 分析烧录后的 reset 行为
- 启动 OpenOCD 以配合 GDB 做基础调试
- 区分探针连接失败、目标访问失败和程序写入失败

## 工作流程

1. 从已确认无误的产物开始。
   使用构建步骤已经确认过的 `.elf` 或其他目标镜像。

2. 复用工程已有 OpenOCD 配置。
   优先使用工程已经采用的 interface cfg 和 target cfg，不随意猜测目标文件。

3. 使用显式烧录命令。
   常规循环优先围绕 `program <artifact> verify reset exit`。

4. 明确区分失败类型：
   - 探针连不上
   - 探针能连，但目标板访问失败
   - 目标可 halt，但写不进去
   - 写入成功，但运行行为没变化

5. 只有在正常烧录链路稳定后，才引入更深调试。
   包括 GDB server、OpenOCD telnet、手动 reset 序列等。

## 操作规则

- 除非用户要求或恢复确实需要，不要做大范围擦除。
- 除非 OpenOCD 已明确不可用，不要在调试中途切换烧录后端。
- interface cfg 和 target cfg 必须写明确。
- `verify` 视为正常烧录流程的一部分。

## 判断优先级

- 如果烧录提示成功，但板子行为没变，先检查 artifact 路径，而不是先改代码。
- 如果 OpenOCD 连接不稳定，优先检查线缆、探针、供电、reset，而不是先改固件。
- 如果 target cfg 不明确，优先从工程已使用的 MCU 系列入手，不要凭空猜测。

## 参考资料

- 需要常用 OpenOCD 命令模板和故障拆分方式时，读 [references/playbook.md](references/playbook.md)。
