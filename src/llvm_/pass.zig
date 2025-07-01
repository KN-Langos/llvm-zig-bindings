const module = @import("module.zig");
const types = @import("types.zig");

pub const PassManager = opaque {
    pub const create = LLVMCreatePassManager;
    extern fn LLVMCreatePassManager() *PassManager;

    pub fn dispose(self: *PassManager) bool {
        return !LLVMDisposePassManager(self).toBool();
    }
    extern fn LLVMDisposePassManager(PM: *PassManager) types.Bool;

    pub fn runOnModule(self: *PassManager, mod: *module.Module) bool {
        return !LLVMRunPassManager(self, mod).toBool();
    }
    extern fn LLVMRunPassManager(PM: *PassManager, M: *module.Module) *types.Bool;
};
