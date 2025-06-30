pub const Value = opaque {};

pub const FnValue = opaque {
    pub const appendBasicBlock = LLVMAppendBasicBlock;
    extern fn LLVMAppendBasicBlock(self: *FnValue, name: [*:0]const u8) *BasicBlock;

    pub const getParam = LLVMGetParam;
    extern fn LLVMGetParam(self: *FnValue, idx: c_uint) *Value;
};

pub const BasicBlock = opaque {};

pub const Builder = opaque {
    pub const create = LLVMCreateBuilder;
    extern fn LLVMCreateBuilder() *Builder;

    pub const dispose = LLVMDisposeBuilder;
    extern fn LLVMDisposeBuilder(b: *Builder) void;

    pub const positionAtEnd = LLVMPositionBuilderAtEnd;
    extern fn LLVMPositionBuilderAtEnd(self: *Builder, bb: *BasicBlock) void;

    // All build* functions.
    pub const buildAdd = LLVMBuildAdd;
    extern fn LLVMBuildAdd(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildRet = LLVMBuildRet;
    extern fn LLVMBuildRet(self: *Builder, arg: *Value) *Value;
    pub const buildRetVoid = LLVMBuildRet;
    extern fn LLVMBuildRetVoid(self: *Builder) *Value;
};
