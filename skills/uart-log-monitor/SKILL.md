---
name: uart-log-monitor
description: 用于通过 UART 日志确认 STM32 固件运行状态或分析运行时问题。Use this skill for STM32 runtime validation from UART logs, baud selection, startup checks, timestamp correlation, and structured serial analysis.
---

# UART 日志监视

当任务依赖串口输出判断固件是否真正运行、运行到了哪里、时序是否正常时，使用这个 skill。它只负责串口日志层，不负责构建和烧录。

## 适用场景

- 打开并验证 UART 监视会话
- 烧录后检查启动日志
- 确认串口端口、波特率和输出格式
- 设计适合 bring-up 或数据流调试的稳定日志格式
- 关联时间戳、序号和运行时状态
- 区分运行时逻辑问题与旧固件、错误烧录导致的问题

## 工作流程

1. 先识别当前 UART 链路。
   复用工程当前使用的 COM 口、波特率和串口格式。

2. 在解释日志前，先确认监视链路有效。
   保证串口设置与固件匹配，输出不是乱码，也不是历史残留内容。

3. 优先使用稳定的行格式。
   建议显式输出 tag、sequence、timestamp、freshness 等字段。

4. 结合上下文分析日志。
   把源码修改、构建结果、烧录结果和 UART 输出一起判断，不单看串口文本。

5. 先缩小运行时问题范围，再改通信参数。
   在最小可疑路径周围加日志，而不是先改波特率或传输方式。

## 操作规则

- 当构建和烧录链路未确认时，不要只凭日志就判断固件更新成功。
- 只要问题涉及时序、启动顺序、中断节拍或数据新鲜度，优先加时间戳。
- 周期性数据输出必须保持机器可读。
- 状态日志和数据日志要分开。

## 判断优先级

- 如果烧录后串口没输出，先检查 reset 和波特率，再考虑更深代码改动。
- 如果日志看起来还是旧行为，先怀疑 stale artifact 或 flash 未生效。
- 如果问题和时序相关，必须同时记录时间戳和单调递增序号。

## 参考资料

- 需要日志格式建议和串口观测检查项时，读 [references/playbook.md](references/playbook.md)。
