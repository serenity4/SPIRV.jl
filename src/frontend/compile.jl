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
    fdef = FunctionDefinition()
end
