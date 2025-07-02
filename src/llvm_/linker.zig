const module = @import("module.zig");
const types = @import("types.zig");

pub const Linker = opaque {
    pub fn linkAll(main: *module.Module, rest: []const module.Module) bool {
        for (rest) |mod|
            if (LLVMLinkModules2(main, mod))
                return false;

        return true;
    }

    pub fn link2(dest: *module.Module, src: *module.Module) bool {
        return !LLVMLinkModules2(dest, src).toBool();
    }
    extern fn LLVMLinkModules2(Dest: *module.Module, Src: *module.Module) types.Bool;
};
