const builder = @import("builder.zig");
const module = @import("module.zig");
const types = @import("types.zig");

pub const Context = opaque {
    pub const create = LLVMContextCreate;
    extern fn LLVMContextCreate() *Context;

    pub const dispose = LLVMContextDispose;
    extern fn LLVMContextDispose(C: *Context) void;

    pub fn createModuleWithName(self: *Context, name: [*:0]const u8) *module.Module {
        return LLVMModuleCreateWithNameInContext(name, self);
    }
    extern fn LLVMModuleCreateWithNameInContext(ModuleID: [*:0]const u8, C: *Context) *module.Module;

    pub const intType = LLVMIntTypeInContext;
    extern fn LLVMIntTypeInContext(C: *Context, NumBits: c_uint) *types.Type;

    pub const voidType = LLVMVoidTypeInContext;
    extern fn LLVMVoidTypeInContext(C: *Context) *types.Type;

    pub fn structType(self: *Context, elements: []const *const types.Type, is_packed: bool) *types.Type {
        return LLVMStructTypeInContext(self, elements.ptr, @truncate(elements.len), .fromBool(is_packed));
    }
    extern fn LLVMStructTypeInContext(C: *Context, ElementTypes: [*]const *const types.Type, ElementCount: c_uint, Packed: types.Bool) *types.Type;

    pub fn structTypeNamed(self: *Context, elements: []const *const types.Type, is_packed: bool, name: [*:0]const u8) *types.Type {
        const struct_type = LLVMStructCreateNamed(self, name);
        LLVMStructSetBody(struct_type, elements.ptr, @truncate(elements.len), .fromBool(is_packed));
        return struct_type;
    }
    extern fn LLVMStructSetBody(Struct: *types.Type, ElementTypes: [*]const *const types.Type, ElementCount: c_uint, Packed: types.Bool) void;
    extern fn LLVMStructCreateNamed(C: *Context, Name: [*:0]const u8) *types.Type;

    pub const pointerType = LLVMPointerTypeInContext;
    extern fn LLVMPointerTypeInContext(C: *Context, AddressSpace: c_uint) *types.Type;

    pub const labelType = LLVMLabelTypeInContext;
    extern fn LLVMLabelTypeInContext(C: *Context) *types.Type;

    pub const tokenType = LLVMTokenTypeInContext;
    extern fn LLVMTokenTypeInContext(C: *Context) *types.Type;

    pub const metadataType = LLVMMetadataTypeInContext;
    extern fn LLVMMetadataTypeInContext(C: *Context) *types.Type;

    pub const createBuilder = LLVMCreateBuilderInContext;
    extern fn LLVMCreateBuilderInContext(C: *Context) *builder.Builder;
};
