function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}))
    original = CFG(f, argtypes)
    inferred = infer!(original)
    SPIRV.Module(inferred)
end

function SPIRV.Module(cfg::CFG)
    cfg
end
