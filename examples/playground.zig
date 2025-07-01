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

    // Build functions
    const fn_type = llvm.types.Type.functionType(ctx.intType(32), &.{
        ctx.intType(32),
        ctx.intType(32),
    }, false);
    const sum_fn = module.addFunction("sum", fn_type);
    sum_fn.setCC(.Fast);
    const entry_bb = sum_fn.appendBasicBlock("entry");

    const builder = ctx.createBuilder();
    defer builder.dispose();

    builder.positionAtEnd(entry_bb);
    const a = sum_fn.getParam(0);
    const b = sum_fn.getParam(1);
    const sum = builder.buildAdd(a, b, "sum");
    _ = builder.buildRet(sum);

    const start_fn_type = llvm.types.Type.functionType(ctx.intType(32), &.{}, false);
    const start_fn = module.addFunction("_start", start_fn_type);
    const start_entry_bb = start_fn.appendBasicBlock("entry");

    builder.positionAtEnd(start_entry_bb);
    const sum2 = builder.buildCall(fn_type, sum_fn.asValue(), &.{
        llvm.builder.Constant.constInt(ctx.intType(32), 2, false),
        llvm.builder.Constant.constInt(ctx.intType(32), 3, false),
    }, "add_res");
    sum2.setInstCC(.Fast); // Is this necessary?
    _ = builder.buildRet(sum2);

    // Dump and generate asm.
    module.dump();

    const cwd_parent = try std.fs.cwd().realpathAlloc(std.heap.c_allocator, ".");
    const out_dir = try std.fs.path.join(std.heap.c_allocator, &.{ cwd_parent, "ignore-me" });
    std.heap.c_allocator.free(cwd_parent);

    std.fs.makeDirAbsolute(out_dir) catch {
        std.debug.print("Skipping directory creation as it probably already exists.\n", .{});
    };
    const out_file = try std.fs.path.join(std.heap.c_allocator, &.{ out_dir, "playground.asm" });
    std.heap.c_allocator.free(out_dir);
    defer std.heap.c_allocator.free(out_file);

    const out_c = try toSentinel(out_file, std.heap.c_allocator);
    defer std.heap.c_allocator.free(out_c[0..out_file.len :0]);

    _ = machine.emitModuleToFile(module, out_c, .AssemblyFile);

    llvm.LLVMShutdown();
}

fn toSentinel(str: []const u8, allocator: std.mem.Allocator) ![*:0]const u8 {
    var buf = try allocator.allocSentinel(u8, str.len, 0); // 0 = sentinel
    @memcpy(buf[0..str.len], str);
    return buf;
}
