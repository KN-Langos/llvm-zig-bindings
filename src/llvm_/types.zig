pub const Type = opaque {
    pub fn functionType(return_type: *Type, param_types: []const *const Type, is_vararg: bool) *Type {
        return LLVMFunctionType(return_type, param_types.ptr, @truncate(param_types.len), Bool.fromBool(is_vararg));
    }
    extern fn LLVMFunctionType(ReturnType: *Type, ParamTypes: [*]const *const Type, ParamCount: c_uint, IsVarArg: Bool) *Type;
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
