pub const builder = @import("llvm_/builder.zig");
pub const context = @import("llvm_/context.zig");
pub const module = @import("llvm_/module.zig");
pub const target = @import("llvm_/target.zig");
pub const types = @import("llvm_/types.zig");

pub extern fn LLVMShutdown() void;
