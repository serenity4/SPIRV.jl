function emit(ctx::Context, type::CompositeType)
    member_ids = SSAValue[]
    for field in type.fields
        mid = get_type_id(ctx, field)
        push!(member_ids, mid)
    end
    id = new_ssavalue!(ctx)
    insert!(ctx.type_ids, type.name, id)
    push!(ctx.types, @inst id = SPIRV.OpTypeStruct(member_ids...))
end

function emit(ctx::Context, type::PrimitiveType)
    id = new_ssavalue!(ctx)
    inst = @match type.name begin
        :UInt32 => @inst id = SPIRV.OpTypeInt(32, 0)
        :Int32 => @inst id = SPIRV.OpTypeInt(32, 1)
        :Float32 => @inst id = SPIRV.OpTypeFloat(32)
        t => error("Unknown primitive type '$t'")
    end
    push!(ctx.types, inst)
    id
end

function get_type_id(ctx::Context, type::TypeSpec)
    get!(() -> emit(ctx, type), ctx.type_ids, type.name)
end
