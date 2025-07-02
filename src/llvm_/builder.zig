const types = @import("types.zig");

pub const Value = opaque {
    pub const setInstCC = LLVMSetInstructionCallConv;
    extern fn LLVMSetInstructionCallConv(Instr: *Value, CC: CallConv) void;
};

pub const FnValue = opaque {
    pub const appendBasicBlock = LLVMAppendBasicBlock;
    extern fn LLVMAppendBasicBlock(self: *FnValue, name: [*:0]const u8) *BasicBlock;

    pub const getParam = LLVMGetParam;
    extern fn LLVMGetParam(self: *FnValue, idx: c_uint) *Value;

    pub inline fn asValue(self: *FnValue) *Value {
        return @ptrCast(self);
    }

    pub inline fn asGlobal(self: *FnValue) *GlobalValue {
        return @ptrCast(self);
    }

    pub const setCC = LLVMSetFunctionCallConv;
    extern fn LLVMSetFunctionCallConv(Fn: *FnValue, CC: CallConv) void;
};

pub const GlobalValue = opaque {
    pub const getInitializer = LLVMGetInitializer;
    extern fn LLVMGetInitializer(GlobalVar: *GlobalValue) *Value;

    pub const setInitializer = LLVMSetInitializer;
    extern fn LLVMSetInitializer(GlobalVar: *GlobalValue, ConstantVal: *Value) void;

    pub inline fn asValue(self: *GlobalValue) *Value {
        return @ptrCast(self);
    }

    pub const getSection = LLVMGetSection;
    extern fn LLVMGetSection(Global: *GlobalValue) [*:0]const u8;

    pub const setSection = LLVMSetSection;
    extern fn LLVMSetSection(Global: *GlobalValue, Section: [*:0]const u8) void;

    pub const getLinkage = LLVMGetLinkage;
    extern fn LLVMGetLinkage(Global: *GlobalValue) Linkage;

    pub const setLinkage = LLVMSetLinkage;
    extern fn LLVMSetLinkage(Global: *GlobalValue, Linkage: Linkage) void;
};

pub const Linkage = enum(c_int) {
    External,
    AvailableExternally,
    LinkOnceAny,
    LinkOnceODR,
    LinkOnceODRAutoHide,
    WeakAny,
    WeakODR,
    Appending,
    Internal,
    Private,
    DLLImport,
    DLLExport,
    ExternalWeak,
    Ghost,
    Common,
    LinkerPrivate,
    LinkerPrivateWeak,
};

pub const CallConv = enum(c_int) {
    C = 0,
    Fast = 8,
    Cold,
    GHC,
    HiPE,
    AnyReg = 13,
    PreserveMost,
    PreserveAll,
    Swift,
    CXX_FAST_TLS,
    Tail,
    CFGuardCheck,
    SwiftTail,
    PreserveNone,
    _,
};

pub const SwitchValue = opaque {
    pub const addCase = LLVMAddCase;
    extern fn LLVMAddCase(self: *SwitchValue, OnVal: *Value, Dest: *BasicBlock) void;
};

pub const IndirectBrValue = opaque {
    pub const addDestination = LLVMAddDestination;
    extern fn LLVMAddDestination(self: *IndirectBrValue, Dest: *BasicBlock) void;
};

pub const BasicBlock = opaque {};

pub const Builder = opaque {
    pub const dispose = LLVMDisposeBuilder;
    extern fn LLVMDisposeBuilder(b: *Builder) void;

    pub const positionAtEnd = LLVMPositionBuilderAtEnd;
    extern fn LLVMPositionBuilderAtEnd(self: *Builder, bb: *BasicBlock) void;

    // All build* functions.
    pub const buildRetVoid = LLVMBuildRet;
    extern fn LLVMBuildRetVoid(self: *Builder) *Value;
    pub const buildRet = LLVMBuildRet;
    extern fn LLVMBuildRet(self: *Builder, arg: *Value) *Value;
    pub fn buildAggregateRet(self: *Builder, elements: []const *const Value) *Value {
        return LLVMBuildAggregateRet(self, elements.ptr, @truncate(elements.len));
    }
    extern fn LLVMBuildAggregateRet(self: *Builder, RetVals: [*]const *const Value, N: c_uint) *Value;

    pub const buildBr = LLVMBuildBr;
    extern fn LLVMBuildBr(self: *Builder, Dest: *BasicBlock) *Value;
    pub const buildCondBr = LLVMBuildCondBr;
    extern fn LLVMBuildCondBr(self: *Builder, If: *Value, Then: *BasicBlock, Else: *BasicBlock) *Value;

    pub const buildSwitch = LLVMBuildSwitch;
    extern fn LLVMBuildSwitch(self: *Builder, If: *Value, Else: *BasicBlock, NumCases: c_uint) *SwitchValue;

    pub const buildIndirectBr = LLVMBuildIndirectBr;
    extern fn LLVMBuildIndirectBr(self: *Builder, Addr: *Value, NumDests: c_uint) *IndirectBrValue;

    // TODO: Implement LLVMBuildCallBr once I understand what the heck it does.
    // TODO: Implement LLVMBuildInvoke2 and LLVMBuildInvokeWithOperandBundles if necessary.

    pub const buildUnreachable = LLVMBuildUnreachable;
    extern fn LLVMBuildUnreachable(self: *Builder) *Value;

    pub const buildResume = LLVMBuildResume;
    extern fn LLVMBuildResume(self: *Builder, Exn: *Value) *Value;

    // Some deprecated stuff is skipped here.

    pub const buildAdd = LLVMBuildAdd;
    extern fn LLVMBuildAdd(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildNSWAdd = LLVMBuildNSWAdd;
    extern fn LLVMBuildNSWAdd(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildNUWAdd = LLVMBuildNUWAdd;
    extern fn LLVMBuildNUWAdd(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildFAdd = LLVMBuildFAdd;
    extern fn LLVMBuildFAdd(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildSub = LLVMBuildSub;
    extern fn LLVMBuildSub(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildNSWSub = LLVMBuildNSWSub;
    extern fn LLVMBuildNSWSub(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildNUWSub = LLVMBuildNUWSub;
    extern fn LLVMBuildNUWSub(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildFSub = LLVMBuildFSub;
    extern fn LLVMBuildFSub(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildMul = LLVMBuildMul;
    extern fn LLVMBuildMul(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildNSWMul = LLVMBuildNSWMul;
    extern fn LLVMBuildNSWMul(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildNUWMul = LLVMBuildNUWMul;
    extern fn LLVMBuildNUWMul(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildFMul = LLVMBuildFMul;
    extern fn LLVMBuildFMul(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildUDiv = LLVMBuildUDiv;
    extern fn LLVMBuildUDiv(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildExactUDiv = LLVMBuildExactUDiv;
    extern fn LLVMBuildExactUDiv(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildSDiv = LLVMBuildSDiv;
    extern fn LLVMBuildSDiv(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildExactSDiv = LLVMBuildExactSDiv;
    extern fn LLVMBuildExactSDiv(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildFDiv = LLVMBuildFDiv;
    extern fn LLVMBuildFDiv(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildURem = LLVMBuildURem;
    extern fn LLVMBuildURem(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildSRem = LLVMBuildSRem;
    extern fn LLVMBuildSRem(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildFRem = LLVMBuildFRem;
    extern fn LLVMBuildFRem(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildShl = LLVMBuildShl;
    extern fn LLVMBuildShl(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildLShr = LLVMBuildLShr;
    extern fn LLVMBuildLShr(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildAShr = LLVMBuildAShr;
    extern fn LLVMBuildAShr(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildAnd = LLVMBuildAnd;
    extern fn LLVMBuildAnd(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildOr = LLVMBuildOr;
    extern fn LLVMBuildOr(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;
    pub const buildXor = LLVMBuildXor;
    extern fn LLVMBuildXor(self: *Builder, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    // pub const buildBinOp = LLVMBuildBinOp;
    // extern fn LLVMBuildBinOp(self: *Builder, op: BinOp, arg1: *Value, arg2: *Value, name: [*:0]const u8) *Value;

    pub const buildNeg = LLVMBuildNeg;
    extern fn LLVMBuildNeg(self: *Builder, arg: *Value, name: [*:0]const u8) *Value;
    pub const buildNSWNeg = LLVMBuildNSWNeg;
    extern fn LLVMBuildNSWNeg(self: *Builder, arg: *Value, name: [*:0]const u8) *Value;
    pub const buildFNeg = LLVMBuildFNeg;
    extern fn LLVMBuildFNeg(self: *Builder, arg: *Value, name: [*:0]const u8) *Value;
    pub const buildNot = LLVMBuildNot;
    extern fn LLVMBuildNot(self: *Builder, arg: *Value, name: [*:0]const u8) *Value;

    pub const buildMalloc = LLVMBuildMalloc;
    extern fn LLVMBuildMalloc(self: *Builder, ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildArrayMalloc = LLVMBuildArrayMalloc;
    extern fn LLVMBuildArrayMalloc(self: *Builder, ty: *types.Type, size: *Value, name: [*:0]const u8) *Value;

    pub const buildMemSet = LLVMBuildMemSet;
    extern fn LLVMBuildMemSet(self: *Builder, ptr: *Value, value: *Value, len: *Value, Align: c_uint) *Value;

    pub const buildMemCpy = LLVMBuildMemCpy;
    extern fn LLVMBuildMemCpy(self: *Builder, dst: *Value, dst_align: c_uint, src: *Value, src_align: c_uint, size: *Value) *Value;

    pub const buildMemMove = LLVMBuildMemMove;
    extern fn LLVMBuildMemMove(self: *Builder, dst: *Value, dst_align: c_uint, src: *Value, src_align: c_uint, size: *Value) *Value;

    pub const buildAlloca = LLVMBuildAlloca;
    extern fn LLVMBuildAlloca(self: *Builder, ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildArrayAlloca = LLVMBuildArrayAlloca;
    extern fn LLVMBuildArrayAlloca(self: *Builder, ty: *types.Type, size: *Value, name: [*:0]const u8) *Value;

    pub const buildFree = LLVMBuildFree;
    extern fn LLVMBuildFree(self: *Builder, ptr: *Value) *Value;

    pub const buildLoad = LLVMBuildLoad2;
    extern fn LLVMBuildLoad2(self: *Builder, ty: *types.Type, ptr: *Value, name: [*:0]const u8) *Value;

    pub const buildStore = LLVMBuildStore;
    extern fn LLVMBuildStore(self: *Builder, val: *Value, ptr: *Value) *Value;

    pub fn buildGEP(
        self: *Builder,
        ty: *types.Type,
        ptr: *Value,
        indices: []const *const Value,
        name: [*:0]const u8,
    ) *Value {
        return LLVMBuildGEP2(self, ty, ptr, indices.ptr, @truncate(indices.len), name);
    }
    extern fn LLVMBuildGEP2(
        self: *Builder,
        ty: *types.Type,
        ptr: *Value,
        indices: [*]const *const Value,
        indices_num: c_uint,
        name: [*:0]const u8,
    ) *Value;

    pub fn buildInBoundsGEP(
        self: *Builder,
        ty: *types.Type,
        ptr: *Value,
        indices: []const *const Value,
        name: [*:0]const u8,
    ) *Value {
        return LLVMBuildInBoundsGEP2(self, ty, ptr, indices.ptr, @truncate(indices.len), name);
    }
    extern fn LLVMBuildInBoundsGEP2(
        self: *Builder,
        ty: *types.Type,
        ptr: *Value,
        indices: [*]const *const Value,
        indices_num: c_uint,
        name: [*:0]const u8,
    ) *Value;

    // TODO: LLVMBuildGEPWithNoWrapFlags

    pub const buildStructGEP = LLVMBuildStructGEP2;
    extern fn LLVMBuildStructGEP2(self: *Builder, ty: *types.Type, ptr: *Value, index: c_uint, name: [*:0]const u8) *Value;

    pub const buildGlobalString = LLVMBuildGlobalString;
    extern fn LLVMBuildGlobalString(self: *Builder, content: [*:0]const u8, name: [*:0]const u8) *GlobalValue;
    pub const buildGlobalStringPtr = LLVMBuildGlobalStringPtr;
    extern fn LLVMBuildGlobalStringPtr(self: *Builder, content: [*:0]const u8, name: [*:0]const u8) *GlobalValue;

    pub const buildTrunc = LLVMBuildTrunc;
    extern fn LLVMBuildTrunc(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildZExt = LLVMBuildZExt;
    extern fn LLVMBuildZExt(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;
    pub const buildSExt = LLVMBuildSExt;
    extern fn LLVMBuildSExt(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildFPToUI = LLVMBuildFPToUI;
    extern fn LLVMBuildFPToUI(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;
    pub const buildFPToSI = LLVMBuildFPToSI;
    extern fn LLVMBuildFPToSI(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;
    pub const buildUIToFP = LLVMBuildUIToFP;
    extern fn LLVMBuildUIToFP(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;
    pub const buildSIToFP = LLVMBuildSIToFP;
    extern fn LLVMBuildSIToFP(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildFPTrunc = LLVMBuildFPTrunc;
    extern fn LLVMBuildFPTrunc(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildFPExt = LLVMBuildFPExt;
    extern fn LLVMBuildFPExt(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildPtrToInt = LLVMBuildPtrToInt;
    extern fn LLVMBuildPtrToInt(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;
    pub const buildIntToPtr = LLVMBuildIntToPtr;
    extern fn LLVMBuildIntToPtr(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildBitCast = LLVMBuildBitCast;
    extern fn LLVMBuildBitCast(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildAddrSpaceCast = LLVMBuildAddrSpaceCast;
    extern fn LLVMBuildAddrSpaceCast(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildZExtOrBitCast = LLVMBuildZExtOrBitCast;
    extern fn LLVMBuildZExtOrBitCast(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;
    pub const buildSExtOrBitCast = LLVMBuildSExtOrBitCast;
    extern fn LLVMBuildSExtOrBitCast(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;
    pub const buildTruncOrBitCast = LLVMBuildTruncOrBitCast;
    extern fn LLVMBuildTruncOrBitCast(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildPointerCast = LLVMBuildPointerCast;
    extern fn LLVMBuildPointerCast(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub fn buildIntCast2(self: *Builder, val: *Value, dest_ty: *types.Type, is_signed: bool, name: [*:0]const u8) *Value {
        return LLVMBuildIntCast2(self, val, dest_ty, types.Bool.fromBool(is_signed), name);
    }
    extern fn LLVMBuildIntCast2(self: *Builder, val: *Value, dest_ty: *types.Type, is_signed: types.Bool, name: [*:0]const u8) *Value;

    pub const buildFPCast = LLVMBuildFPCast;
    extern fn LLVMBuildFPCast(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;
    pub const buildIntCast = LLVMBuildIntCast;
    extern fn LLVMBuildIntCast(self: *Builder, val: *Value, dest_ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildICmp = LLVMBuildICmp;
    extern fn LLVMBuildICmp(self: *Builder, op: IntCmpOp, lhs: *Value, rhs: *Value, name: [*:0]const u8) *Value;

    pub const buildFCmp = LLVMBuildFCmp;
    extern fn LLVMBuildFCmp(self: *Builder, op: FPCmpOp, lhs: *Value, rhs: *Value, name: [*:0]const u8) *Value;

    pub const buildPhi = LLVMBuildPhi;
    extern fn LLVMBuildPhi(self: *Builder, ty: *types.Type, name: [*:0]const u8) *Value;

    pub fn buildCall(
        self: *Builder,
        fn_ty: *types.Type,
        fn_ptr: *Value,
        args: []const *const Value,
        name: [*:0]const u8,
    ) *Value {
        return LLVMBuildCall2(self, fn_ty, fn_ptr, args.ptr, @truncate(args.len), name);
    }
    extern fn LLVMBuildCall2(
        self: *Builder,
        FnTy: *types.Type,
        Fn: *Value,
        Args: [*]const *const Value,
        NumArgs: c_uint,
        name: [*:0]const u8,
    ) *Value;

    pub const buildSelect = LLVMBuildSelect;
    extern fn LLVMBuildSelect(self: *Builder, If: *Value, Then: *BasicBlock, Else: *BasicBlock, name: [*:0]const u8) *Value;

    pub const buildVAArg = LLVMBuildVAArg;
    extern fn LLVMBuildVAArg(self: *Builder, List: *Value, Ty: *types.Type, name: [*:0]const u8) *Value;

    pub const buildExtractElement = LLVMBuildExtractElement;
    extern fn LLVMBuildExtractElement(self: *Builder, VecVal: *Value, Index: *Value, name: [*:0]const u8) *Value;
    pub const buildInsertElement = LLVMBuildInsertElement;
    extern fn LLVMBuildInsertElement(self: *Builder, VecVal: *Value, EltVal: *Value, Index: *Value, name: [*:0]const u8) *Value;

    pub const buildShuffleVector = LLVMBuildShuffleVector;
    extern fn LLVMBuildShuffleVector(self: *Builder, V1: *Value, V2: *Value, Mask: *Value, name: [*:0]const u8) *Value;

    pub const buildExtractValue = LLVMBuildExtractValue;
    extern fn LLVMBuildExtractValue(self: *Builder, AggVal: *Value, Index: c_uint, name: [*:0]const u8) *Value;
    pub const buildInsertValue = LLVMBuildInsertValue;
    extern fn LLVMBuildInsertValue(self: *Builder, AggVal: *Value, EltVal: *Value, Index: c_uint, name: [*:0]const u8) *Value;

    pub const buildFreeze = LLVMBuildFreeze;
    extern fn LLVMBuildFreeze(self: *Builder, Val: *Value, name: [*:0]const u8) *Value;

    pub const buildIsNull = LLVMBuildIsNull;
    extern fn LLVMBuildIsNull(self: *Builder, Val: *Value, name: [*:0]const u8) *Value;
    pub const buildIsNotNull = LLVMBuildIsNotNull;
    extern fn LLVMBuildIsNotNull(self: *Builder, Val: *Value, name: [*:0]const u8) *Value;

    pub const buildPtrDiff = LLVMBuildPtrDiff2;
    extern fn LLVMBuildPtrDiff2(self: *Builder, ElemTy: *types.Type, LHS: *Value, RHS: *Value, name: [*:0]const u8) *Value;

    // TODO: Fences and atomics
};

pub const IntCmpOp = enum(c_uint) { EQ = 32, NE, UGT, UGE, ULT, ULE, SGT, SGE, SLT, SLE };
pub const FPCmpOp = enum(c_uint) { PredicateFalse, OEQ, OGT, OGE, OLT, OLE, ONE, ORD, UNO, UEQ, UGT, UGE, ULT, ULE, UNE, PredicateTrue };

pub const Constant = opaque {
    pub fn constInt(int_ty: *types.Type, value: u64, sign_extend: bool) *Value {
        return LLVMConstInt(int_ty, @intCast(value), types.Bool.fromBool(sign_extend));
    }
    extern fn LLVMConstInt(IntTy: *types.Type, Value: c_ulonglong, SignExtend: types.Bool) *Value;

    pub fn constReal(int_ty: *types.Type, value: f64) *Value {
        return LLVMConstReal(int_ty, @floatCast(value));
    }
    extern fn LLVMConstReal(IntTy: *types.Type, Value: c_longdouble) *Value;

    pub fn constString(str: [*:0]const u8, no_sentinel: bool) *Value {
        return LLVMConstString(str.ptr, @truncate(str.len), types.Bool.fromBool(no_sentinel));
    }
    extern fn LLVMConstString(Str: [*:0]const u8, Length: c_uint, DontNullTerminate: types.Bool) *Value;

    pub fn constStruct(elements: []const *Value, is_packed: bool) *Value {
        return LLVMConstStruct(elements.ptr, @truncate(elements.len), types.Bool.fromBool(is_packed));
    }
    extern fn LLVMConstStruct(ConstantVals: [*]const *const Value, Count: c_uint, is_packed: types.Bool) *Value;

    pub fn constArray(element_type: *types.Type, elements: []const *Value) *Value {
        return LLVMConstArray2(element_type, elements.ptr, @intCast(elements.len));
    }
    extern fn LLVMConstArray2(ElementType: *types.Type, ConstantVals: [*]const *const Value, Count: c_ulonglong) *Value;
};
