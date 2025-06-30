# Zig bindings for LLVM and libclang
[![GitHub License](https://img.shields.io/github/license/KN-langos/llvm-zig-bindings)]()
[![GitHub Repo stars](https://img.shields.io/github/stars/KN-langos/llvm-zig-bindings)]()
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/KN-langos/llvm-zig-bindings/ci.yml?label=CI%20Tests)]()

This zig library provides zig-style bindings for LLVM and libclang.

These bindings are made for internal purposes of our science club,
therefore we do not guarantee that everything will be supported in the future
nor that there will be no breaking changes on the main branch.

## Requirements
Using this library requires the following to be available on the system:
- LLVM-C (preferably version 19),
- libclang,
- zstd,
- ole32 (for windows).

## Usage
To add this library to your zig project, first use this zig command:
```bash
zig fetch --save=llvm_zig git+https://github.com/KN-langos/llvm-zig-bindings
```
And then modify your `build.zig` to include them:
```zig
    // [...]
    const llvm_dep = b.dependency("llvm_zig", .{
        .target = target,
        .optimize = optimize,
    });
    const llvm_mod = llvm_dep.module("llvm-zig");
    const clang_mod = llvm_dep.module("clang-zig");

    exe.root_module.addImport("llvm", llvm_mod);
    exe.root_module.addImport("clang", clang_mod);
    // [...]
```

## Running examples
To run examples just use the following zig command:
```bash
zig build -Dexamples <example name> // e.g. zig build -Dexample playground
```

## What about tests?
This project does not contain tests at the moment.
We plan on having partial coverage (especially all builder functions and emission related features),
but as with the rest of this codebase, we will only test what we need internally.

## TODO/Done
- [x] Basic llvm bindings for target and module
- [x] Basic builder functions
- [ ] Debug information and other metadata
- [ ] Validation and asm emission
- [ ] Bindings to libclang
- [ ] Unit tests
