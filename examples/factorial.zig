const std = @import("std");

const llvm = @import("llvm");

// This example is based on "https://github.com/kassane/llvm-zig".
pub fn main() !void {
    // Get target triple for the host system.
    const native_triple = llvm.target.Target.getDefaultTriple();
    std.debug.print("Found target triple to be '{s}'.\n", .{native_triple});

    // Initiate all target information.
    llvm.target.TargetArch.initAllTargetInfos();
    const target = llvm.target.Target.fromTriple(native_triple);

    // Define architecture as X86 and initialize It. This will be replaced by target.getArch() in the future.
    const arch = if (@import("builtin").target.os.tag == .macos) llvm.target.TargetArch.AArch64 else llvm.target.TargetArch.X86;
    arch.initFull();

    // Create target machine, "generic" is cpu (for specialized instructions) and "" are available cpu features.
    const machine = llvm.target.TargetMachine.create(
        target,
        native_triple,
        "generic",
        "",
        .Default,
        .Default,
        .Default,
    );

    // Create data layout for our chosen machine.
    const target_layout = machine.createTargetDataLayout();
    defer target_layout.dispose();

    // Create context and module.
    const ctx = llvm.types.Context.create();
    defer ctx.dispose();
    const module = ctx.createModuleWithName("factorial_module");
    defer module.dispose();

    // Create builder.
    const builder = ctx.createBuilder();
    defer builder.dispose();

    // Create "factorial" function.
    const return_type = ctx.intType(32);
    const param_types = &.{ctx.intType(32)};
    const factorial_func_type = llvm.types.Type.functionType(return_type, param_types, false);
    const factorial_func = module.addFunction("factorial", factorial_func_type);

    // Make all blocks we will need.
    const entry_bb = factorial_func.appendBasicBlock("entry");
    const init_bb = factorial_func.appendBasicBlock("init");
    const cond_bb = factorial_func.appendBasicBlock("cond");
    const body_bb = factorial_func.appendBasicBlock("body");
    const end_bb = factorial_func.appendBasicBlock("end");

    // Build "entry" basic block.
    builder.positionAtEnd(entry_bb);
    const n = factorial_func.getParam(0);

    // Allocate everything we will need on the stack and go to the next block.
    const result_ptr = builder.buildAlloca(return_type, "result_ptr");
    const n_ptr = builder.buildAlloca(return_type, "n_ptr");
    _ = builder.buildBr(init_bb);

    // Build "init" basic block.
    builder.positionAtEnd(init_bb);

    // Initialize constants
    _ = builder.buildStore(llvm.builder.Constant.constInt(return_type, 1, false), result_ptr);
    _ = builder.buildStore(n, n_ptr);
    _ = builder.buildBr(cond_bb);

    // Build "cond" basic block.
    builder.positionAtEnd(cond_bb);
    const n_val = builder.buildLoad(return_type, n_ptr, "n_val");
    const is_zero = builder.buildICmp(.EQ, n_val, llvm.builder.Constant.constInt(return_type, 0, false), "n_is_zero");
    _ = builder.buildCondBr(is_zero, end_bb, body_bb);

    // Build "body" basic block.
    builder.positionAtEnd(body_bb);
    const result_val = builder.buildLoad(return_type, result_ptr, "res");
    const new_result = builder.buildMul(result_val, n_val, "new_res");
    _ = builder.buildStore(new_result, result_ptr);

    const new_n = builder.buildSub(n_val, llvm.builder.Constant.constInt(return_type, 1, false), "new_n");
    _ = builder.buildStore(new_n, n_ptr);
    _ = builder.buildBr(cond_bb);

    // Build "end" basic block.
    builder.positionAtEnd(end_bb);
    const final_result = builder.buildLoad(return_type, result_ptr, "final");
    _ = builder.buildRet(final_result);

    // Set details for the module.
    module.setDataLayout(target_layout);
    module.setTargetTriple(native_triple);

    // Verify that the module is correct.
    if (module.verifyModuleAndPrintStderr()) {
        std.debug.print("Module verified successfully.\n", .{});
    } else {
        std.debug.print("\x1B[91mModule verification failed.\x1B[0m\n", .{});
    }

    // Print module IR to stdout and clean up.
    module.dump();
    llvm.LLVMShutdown();
}
