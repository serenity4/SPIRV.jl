function align_block(file; delim=r"=", block_begin=r"@c?enum", block_end=r"^end$")
    lines = readlines(file)
    final_lines = String[]

    is_target_block = false
    block_lines = nothing

    for (i, l) ∈ enumerate(lines)

        if is_target_block
            if !isnothing(match(block_end, l))
                lengths = map(block_lines) do decl
                    first(findfirst(delim, decl)) - 1
                end

                nmax = maximum(lengths)
                j = nmax == first(lengths) ? 2 : 1

                block_lines[j] = rpad(first(block_lines[j], lengths[j]), nmax) * block_lines[j][lengths[j]+1:end]

                append!(final_lines, block_lines)
                push!(final_lines, l)

                is_target_block = false
            else
                push!(block_lines, l)
            end
        else
            push!(final_lines, l)
        end

        if !isnothing(match(block_begin, l))
            block_lines = String[]
            is_target_block = true
        end
    end

    open(file, "w") do io
        print(io, (join(final_lines, '\n')))
    end

    format_file(file, margin=92, align_pair_arrow=true, align_assignment=true, align_struct_field=true, align_conditional=true)
end

custom_print(io::IO, expr::Expr) = println(io, prettify(expr))

function format()
    inst_file = src_dir("generated", "instructions.jl")
    enum_file = src_dir("generated", "enums.jl")

    @info "Formatting."

    # initial formatting
    format_file(inst_file, margin=92)
    format_file(enum_file, margin=92)

    # align blocks
    align_block(inst_file)
    align_block(inst_file, block_begin=r"const class_printing = Dict\(", block_end=r"^\)$", delim=r"=>")
    align_block(inst_file, block_begin=r"const kind_to_category = Dict\(", block_end=r"^\)$", delim=r"=>")

    align_block(enum_file)

    true
end
