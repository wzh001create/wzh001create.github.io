# STM32 CMake Build Playbook

## Default Loop

1. Inspect presets:
   - check `CMakePresets.json`
   - prefer the preset already used by the project, often `Debug`

2. Configure:

```powershell
cmake --preset Debug
```

3. Build:

```powershell
cmake --build --preset Debug
```

4. Confirm outputs:
   - `.elf`
   - `.bin` if generated
   - `.map` if generated
   - size output if the project emits it

## Decision Rules

### Configure failures

- Check preset name
- Check generator
- Check toolchain path
- Check environment assumptions

### Compile failures

- Fix source or include path issues before touching flash steps
- Verify generated files actually exist when headers look missing

### Artifact ambiguity

- Prefer project-defined output locations
- Do not guess the `.elf` path when multiple targets exist
