function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}))
    original = CFG(f, argtypes)
    inferred = infer!(original)
    SPIRV.Module(inferred)
end

function SPIRV.Module(cfg::CFG)
    ir = IR(Metadata(SPIRV.magic_number, magic_number, v"1", 0))
    emit!(ir, cfg)
end

function emit!(ir::IR, cfg::CFG)
    ftype = FunctionType(cfg.mi)
    fdef = FunctionDefinition(ftype, FunctionControlNone, [], SSADict())
end

function FunctionType(mi::MethodInstance)
    argtypes = map(SPIRType, Base.tuple_type_tail(mi.specTypes).types)
    FunctionType(SPIRType(mi.cache.rettype), argtypes)
end

function SPIRType(@nospecialize(t::Type))
    @match t begin
        &Float16 => FloatType(16)
        &Float32 => FloatType(32)
        &Float64 => FloatType(64)
        &Nothing => VoidType()
        &Bool => BooleanType()
        &UInt8 => IntegerType(8, false)
        &UInt16 => IntegerType(16, false)
        &UInt32 => IntegerType(32, false)
        &UInt64 => IntegerType(64, false)
        &Int8 => IntegerType(8, true)
        &Int16 => IntegerType(16, true)
        &Int32 => IntegerType(32, true)
        &Int64 => IntegerType(64, true)
        ::Type{<:Array} => begin
            eltype, n = t.parameters
            @match n begin
                1 => ArrayType(SPIRType(eltype), nothing)
                _ => ArrayType(SPIRType(Array{eltype,n-1}), nothing)
            end
        end
        ::Type{<:Tuple} => @match n = length(t.types) begin
                GuardBy(>(1)) => begin
                    @match t begin
                        ::Type{<:NTuple} => ArrayType(eltype(t), Constant(n))
                    end
                end
                _ => error("Unsupported $n-element tuple type $t")
            end
        GuardBy(isstructtype) => StructType(SPIRType.(t.types), Dictionary(), Dictionary(1:length(t.types), fieldnames(t)))
        _ => error("Type $t does not have a corresponding SPIR-V type.")
    end
end
