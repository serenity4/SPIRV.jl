function emit(fctx::FunctionContext, call::FunctionCall)
    (; ir) = fctx.ctx
    result_id = new_ssavalue!(fctx)
    id = get_func_id(fctx, call)
    fdef = ir.fdefs[id]
    rtype_id = ir.types[fdef.type].rettype
    emit(fctx, call, @inst result_id = SPIRV.OpFunctionCall(id, call.args...)::rtype_id)
end

function emit(fctx::FunctionContext, expr::ConstructorCall)
    result_id = new_ssavalue!(ctx)
    argtypes = type.(expr.args)
    id = get_func_id(ctx, expr.op, argtypes)
    rtype = get_rtype(ctx, func, argtypes)
    type_id = get_type_id(ctx, rtype)
    emit(fctx, @inst result_id = SPIRV.OpFunctionCall(id, expr.args...)::type_id)
end

function emit(ctx, func::Func)
    arg_ids = get_type_id.(ctx, func.sig.argtypes)
    fctx = FunctionContext(ctx)
    id = get_sig_id(Signature(func.sig.name, arg_ids))
    insert!(ctx.sigs, Signature(func.sig.name, arg_ids), id)

    exs = body(func)
    for (i, ex) in enumerate(exs)
        ret = emit(fctx, ex)
    end
    insert!(ctx.ir.fdefs, id, SPIRV.FunctionDefinition(id, SPIRV.FunctionControlNone, arg_ids, fctx.cfg))
end

get_sig_id(ctx, sig::Signature) = get!(Base.Fix1(new_ssavalue!, ctx), ctx.sigs, sig)

function get_func_id(ctx, op, argtypes)
    ids = get_type_id.(ctx, argtypes)
    get_sig_id(ctx, Signature(op, ids))
end

function get_func_id(fctx::FunctionContext, call::FunctionCall)
    get_func_id(fctx, call.op, type.(call.args))
end
