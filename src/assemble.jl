function convert(::Type{PhysicalModule}, mod::Module)
    PhysicalModule(mod.magic_number, mod.generator_magic_number, spirv_version(mod.version), mod.bound, mod.schema, mod.instructions)
end

function convert(::Type{PhysicalInstruction}, inst::Instruction)
    operands = physical_operands(inst)
    PhysicalInstruction(1 + length(operands) + !isnothing(inst.type_id) + !isnothing(inst.result_id), inst.opcode, inst.type_id, inst.result_id, operands)
end

function physical_operands(inst::Instruction)
    operands = Word[]
    opcode = inst.opcode
    op_infos = info(inst)
    arguments = inst.arguments
    for (i, (info, arg)) in enumerate(zip(op_infos, arguments))
        kind = info.kind
        if hasproperty(info, :quantifier)
            quantifier = info.quantifier
            @match quantifier begin
                "*" => begin
                    foreach(arguments[i:end]) do arg
                        add_operand!(operands, arg, kind)
                    end
                    break
                end
                "?" => begin
                    nmissing = length(arguments) - (i - 1)
                    nopt = count(x -> hasproperty(x, :quantifier) && x.quantifier == "?", op_infos[i:end])
                    if nmissing == nopt
                        add_operand!(operands, arg, kind)
                    elseif nmissing > 0
                        error("Unsupported number of values: found $nmissing values for $nopt optional arguments")
                    end
                end
            end
        else
            add_operand!(operands, arg, kind)
        end
    end

    operands
end

function add_operand!(operands, arg, kind)
    @match kind begin
        &LiteralString => begin
            utf8_chars = collect(transcode(UInt8, arg))
            push!(utf8_chars, '\0')
            nrem = length(utf8_chars) % 4
            if nrem ≠ 0
                append!(utf8_chars, zeros(4 - nrem))
            end
            append!(operands, reinterpret(UInt32, utf8_chars))
        end
        _ => @match arg begin
            ::Vector{Word} => append!(operands, arg)
            _ => begin
                if kind isa Literal
                    sizeof(arg) <= 4 || error("Literals with a size greater than 32 bits are not supported.")
                end
                push!(operands, arg)
            end
        end 
    end
end

function write(io::IO, mod::PhysicalModule)
    write(io, assemble(mod))
end

assemble(obj) = assemble!(Word[], obj)

function assemble!(words, inst::PhysicalInstruction)
    push!(words, UInt32(inst.word_count) << 16 + inst.opcode)

    # add optional type ID and result ID
    for field in (:type_id, :result_id)
        val = getproperty(inst, field)
        if !isnothing(val)
            push!(words, val)
        end
    end

    append!(words, inst.operands)

    words
end

function assemble!(words, mod::PhysicalModule)
    append!(words, Word[
        mod.magic_number,
        mod.version,
        mod.generator_magic_number,
        mod.bound,
        mod.schema,
    ])

    foreach(mod.instructions) do inst
        assemble!(words, inst)
    end

    words
end

assemble(mod::Module) = assemble(convert(PhysicalModule, mod))
