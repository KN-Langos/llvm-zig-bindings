const module = @import("module.zig");
const target = @import("target.zig");
const types = @import("types.zig");

pub const LegacyPassManager = opaque {
    pub const create = LLVMCreatePassManager;
    extern fn LLVMCreatePassManager() *LegacyPassManager;

    pub fn dispose(self: *LegacyPassManager) bool {
        return !LLVMDisposePassManager(self).toBool();
    }
    extern fn LLVMDisposePassManager(PM: *LegacyPassManager) types.Bool;

    pub fn runOnModule(self: *LegacyPassManager, mod: *module.Module) bool {
        return !LLVMRunPassManager(self, mod).toBool();
    }
    extern fn LLVMRunPassManager(PM: *LegacyPassManager, M: *module.Module) *types.Bool;
};

// https://llvm.org/doxygen/group__LLVMCCoreNewPM.html
pub const PassBuilderOptions = opaque {
    pub const create = LLVMCreatePassBuilderOptions;
    extern fn LLVMCreatePassBuilderOptions() *PassBuilderOptions;

    pub const dispose = LLVMDisposePassBuilderOptions;
    extern fn LLVMDisposePassBuilderOptions(Options: *PassBuilderOptions) void;

    pub fn runOnModule(
        self: PassBuilderOptions,
        mod: *module.Module,
        target_machine: *target.TargetMachine,
        passes: [*:0]const u8,
    ) bool {
        _ = LLVMRunPasses(mod, passes, target_machine, self);
        return true; // TODO: Check error.
    }
    extern fn LLVMRunPasses(M: *module.Module, Passes: [*:0]const u8, TM: *target.TargetMachine, Options: *PassBuilderOptions) *Error;
};

pub const Error = opaque {};
