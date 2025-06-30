pub const Type = opaque {
    pub fn functionType(return_type: *Type, param_types: []const *const Type, is_vararg: bool) *Type {
        return LLVMFunctionType(return_type, param_types.ptr, @truncate(param_types.len), Bool.fromBool(is_vararg));
    }
    extern fn LLVMFunctionType(ReturnType: *Type, ParamTypes: [*]const *const Type, ParamCount: c_uint, IsVarArg: Bool) *Type;

    pub const arrayType = LLVMArrayType;
    extern fn LLVMArrayType(Tp: *Type, ElementCount: c_uint) *Type;
};

pub const Bool = enum(c_int) {
    False,
    True,
    _, // The compiler would complain otherwise...

    pub fn fromBool(b: bool) @This() {
        return @as(@This(), @enumFromInt(@intFromBool(b)));
    }

    pub fn toBool(b: @This()) bool {
        return b != .False;
    }
};

pub const Context = opaque {
    pub const create = LLVMContextCreate;
    extern fn LLVMContextCreate() *Context;

    pub const dispose = LLVMContextDispose;
    extern fn LLVMContextDispose(C: *Context) void;

    pub const intType = LLVMIntTypeInContext;
    extern fn LLVMIntTypeInContext(C: *Context, NumBits: c_uint) *Type;

    pub const voidType = LLVMVoidTypeInContext;
    extern fn LLVMVoidTypeInContext(C: *Context) *Type;

    pub fn structType(self: *Context, elements: []const *const Type, is_packed: bool) *Type {
        return LLVMStructTypeInContext(self, elements.ptr, @truncate(elements.len), Bool.fromBool(is_packed));
    }
    extern fn LLVMStructTypeInContext(C: *Context, ElementTypes: [*]const *const Type, ElementCount: c_uint, Packed: Bool) *Type;

    pub fn structTypeNamed(self: *Context, elements: []const *const Type, is_packed: bool, name: [*:0]const u8) *Type {
        const struct_type = LLVMStructCreateNamed(self, name);
        LLVMStructSetBody(struct_type, elements.ptr, @truncate(elements.len), Bool.fromBool(is_packed));
        return struct_type;
    }
    extern fn LLVMStructSetBody(Struct: *Type, ElementTypes: [*]const *const Type, ElementCount: c_uint, Packed: Bool) void;
    extern fn LLVMStructCreateNamed(C: *Context, Name: [*:0]const u8) *Type;

    pub const pointerType = LLVMPointerTypeInContext;
    extern fn LLVMPointerTypeInContext(C: *Context, AddressSpace: c_uint) *Type;

    pub const labelType = LLVMLabelTypeInContext;
    extern fn LLVMLabelTypeInContext(C: *Context) *Type;

    pub const tokenType = LLVMTokenTypeInContext;
    extern fn LLVMTokenTypeInContext(C: *Context) *Type;

    pub const metadataType = LLVMMetadataTypeInContext;
    extern fn LLVMMetadataTypeInContext(C: *Context) *Type;
};
