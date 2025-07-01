const builder = @import("builder.zig");
const target = @import("target.zig");
const types = @import("types.zig");

pub const Module = opaque {
    pub const setDataLayout = LLVMSetModuleDataLayout;
    extern fn LLVMSetModuleDataLayout(module: *Module, DL: *target.TargetData) void;

    pub const setTargetTriple = LLVMSetTarget;
    extern fn LLVMSetTarget(module: *Module, triple: [*:0]const u8) void;

    pub const dump = LLVMDumpModule;
    extern fn LLVMDumpModule(module: *Module) void;

    pub const dispose = LLVMDisposeModule;
    extern fn LLVMDisposeModule(module: *Module) void;

    pub const addFunction = LLVMAddFunction;
    extern fn LLVMAddFunction(module: *Module, name: [*:0]const u8, FunctionType: *const types.Type) *builder.FnValue;

    pub fn verifyModuleAndPrintStderr(self: *Module) bool {
        var tmp: [*:0]const u8 = undefined;
        return !LLVMVerifyModule(self, .PrintMessage, &tmp).toBool();
    }
    pub const VerifierFailureAction = enum(c_int) { AbortProcess, PrintMessage, ReturnStatus };
    extern fn LLVMVerifyModule(module: *Module, action: VerifierFailureAction, message: *[*:0]const u8) types.Bool;
};
