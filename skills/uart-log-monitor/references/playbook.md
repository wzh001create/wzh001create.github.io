# UART Log Monitor Playbook

## Good Output Shape

Prefer line-oriented logs such as:

```text
LOG,INFO,<tag>,...
DATA,<seq>,<ts>,...
```

## Monitor Checklist

1. Confirm COM port
2. Confirm baud rate
3. Confirm line endings are readable
4. Confirm the log belongs to the current flash cycle
5. Confirm startup ordering if boot flow matters

## Runtime Debug Rules

### If output is garbled

- check baud rate first
- check framing and encoding assumptions
- check whether the device reset during attach

### If output is missing

- check whether the image actually flashed
- check whether the firmware reaches UART init
- check reset and boot path before deeper protocol work

### If data timing matters

- add timestamps
- add sequence numbers
- log freshness or delta fields explicitly
