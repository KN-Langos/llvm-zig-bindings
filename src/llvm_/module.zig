const builder = @import("builder.zig");
const target = @import("target.zig");
const types = @import("types.zig");

pub const Context = opaque {
    pub const create = LLVMContextCreate;
    extern fn LLVMContextCreate() *Context;

    pub const dispose = LLVMContextDispose;
    extern fn LLVMContextDispose(C: *Context) void;

    pub const intType = LLVMIntTypeInContext;
    extern fn LLVMIntTypeInContext(C: *Context, NumBits: c_uint) *types.Type;

    pub const voidType = LLVMVoidTypeInContext;
    extern fn LLVMVoidTypeInContext(C: *Context) *types.Type;
};

pub const Module = opaque {
    pub const createWithName = LLVMModuleCreateWithName;
    extern fn LLVMModuleCreateWithName(ModuleID: [*:0]const u8) *Module;

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
};
