# OpenOCD ST-Link Flash Playbook

## Default Flash Loop

```powershell
openocd -f interface/stlink.cfg -f target/stm32l4x.cfg -c "program <path-to-elf> verify reset exit"
```

Adjust the target cfg only when the workspace already points at another STM32 family.

## Common Tasks

### Normal flash

- connect probe
- program artifact
- verify
- reset target
- exit

### Start GDB server

```powershell
openocd -f interface/stlink.cfg -f target/stm32l4x.cfg
```

## Failure Split

### Probe/connect issues

- ST-Link not detected
- USB or driver problem
- wrong interface cfg

### Target access issues

- wrong target cfg
- bad reset wiring
- target unpowered or held in reset

### Program issues

- wrong artifact path
- protection or memory layout conflict
- stale binary from wrong build folder

### Post-flash runtime mismatch

- verify the flashed image path
- verify reset actually occurred
- confirm runtime logs belong to the new image
