const std = @import("std");

const llvm = @import("llvm");

pub fn main() !void {
    const native_triple = llvm.target.Target.getDefaultTriple();
    std.debug.print("Found target triple to be '{s}'.\n", .{native_triple});

    llvm.target.TargetArch.initAllTargetInfos();
    const target = llvm.target.Target.fromTriple(native_triple);

    const arch = llvm.target.TargetArch.X86;
    arch.initFull();

    const machine = llvm.target.TargetMachine.create(
        target,
        native_triple,
        "generic",
        "",
        .Default,
        .Default,
        .Default,
    );
    const target_layout = machine.createTargetDataLayout();
    defer target_layout.dispose();

    const ctx = llvm.context.Context.create();
    defer ctx.dispose();
    const module = ctx.createModuleWithName("playground_module");
    defer module.dispose();

    module.setDataLayout(target_layout);
    module.setTargetTriple(native_triple);

    const fn_type = llvm.types.Type.functionType(ctx.intType(32), &.{
        ctx.intType(32),
        ctx.intType(32),
    }, false);
    const sum_fn = module.addFunction("sum", fn_type);
    const entry_bb = sum_fn.appendBasicBlock("entry");

    const builder = ctx.createBuilder();
    defer builder.dispose();

    builder.positionAtEnd(entry_bb);
    const a = sum_fn.getParam(0);
    const b = sum_fn.getParam(1);
    const sum = builder.buildAdd(a, b, "sum");
    _ = builder.buildRet(sum);

    module.dump();

    llvm.LLVMShutdown();
}
