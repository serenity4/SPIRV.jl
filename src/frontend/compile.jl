function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}), args...; interp = SPIRVInterpreter())
  compile(CFG(f, argtypes; interp), args...)
end

compile(cfg::CFG, args...) = compile!(IR(), cfg, args...)

function compile!(ir::IR, cfg::CFG, variables::Dictionary{Int,Variable} = Dictionary{Int,Variable}())
  # TODO: restructure CFG
  inferred = infer(cfg)
  emit!(ir, inferred, variables)
  ir
end

function compile!(ir::IR, cfg::CFG, features::FeatureSupport, variables = Dictionary{Int,Variable}())
  ir = compile!(ir, cfg, variables)
  satisfy_requirements!(ir, features)
end

struct IRMapping
  args::Dictionary{Core.Argument,SSAValue}
  "SPIR-V SSA values for basic blocks from Julia IR."
  bbs::Dictionary{Int,SSAValue}
  "SPIR-V SSA values for each `Core.SSAValue` that implicitly represents a basic block."
  bb_ssavals::Dictionary{Core.SSAValue,SSAValue}
  "SPIR-V SSA values that correspond semantically to `Core.SSAValue`s."
  ssavals::Dictionary{Core.SSAValue,SSAValue}
  "Intermediate results that correspond to SPIR-V `Variable`s. Typically, these results have a mutable Julia type."
  variables::Dictionary{Core.SSAValue,Variable}
  types::Dictionary{Type,SSAValue}
  globalrefs::Dictionary{Core.SSAValue,GlobalRef}
end

IRMapping() = IRMapping(Dictionary(), Dictionary(), Dictionary(), Dictionary(), Dictionary(), Dictionary(), Dictionary())

SSAValue(arg::Core.Argument, irmap::IRMapping) = irmap.args[arg]
SSAValue(bb::Int, irmap::IRMapping) = irmap.bbs[bb]
SSAValue(ssaval::Core.SSAValue, irmap::IRMapping) = irmap.ssavals[ssaval]

mutable struct CompilationError <: Exception
  msg::String
  mi::MethodInstance
  jinst::Any
  jtype::Type
  inst::Instruction
  CompilationError(msg::AbstractString) = (err = new(); err.msg = msg; err)
end

function throw_compilation_error(exc::Exception, fields::NamedTuple, msg = "Internal compilation error")
  if isa(exc, CompilationError)
    for (prop, val) in pairs(fields)
      setproperty!(exc, prop, val)
    end
    rethrow()
  else
    err = CompilationError(msg)
    for (prop, val) in pairs(fields)
      setproperty!(err, prop, val)
    end
    throw(err)
  end
end

error_field(field) = string(Base.text_colors[:cyan], field, Base.text_colors[:default], ": ")

function Base.showerror(io::IO, err::CompilationError)
  print(io, "CompilationError")
  if isdefined(err, :mi)
    print(io, " (", err.mi, ")")
  end
  print(io, ": ", err.msg)
  if isdefined(err, :jinst)
    print(io, "\n", error_field("Julia instruction"), err.jinst, Base.text_colors[:yellow], "::", err.jtype, Base.text_colors[:default])
  end
  if isdefined(err, :inst)
    print(io, "\n", error_field("Wrapped SPIR-V instruction"))
    emit(io, err.inst)
  end
  println(io)
end

function emit!(ir::IR, cfg::CFG, variables = Dictionary{Int,Variable}())
  # Declare a new function.
  fdef = define_function!(ir, cfg, variables)
  fid = emit!(ir, fdef)
  set_name!(ir, fid, make_name(cfg.mi))
  irmap = IRMapping()
  arg_idx = 0
  gvar_idx = 0
  for i = 1:(cfg.mi.def.nargs - 1)
    argid = haskey(variables, i) ? fdef.global_vars[gvar_idx += 1] : fdef.args[arg_idx += 1]
    insert!(irmap.args, Core.Argument(i + 1), argid)
    set_name!(ir, argid, cfg.code.slotnames[i + 1])
  end

  try
    # Fill it with instructions using the CFG.
    emit!(fdef, ir, irmap, cfg)
  catch e
    throw_compilation_error(e, (; cfg.mi))
  end
  fid
end

function make_name(mi::MethodInstance)
  Symbol(replace(string(mi.def.name, '_', Base.tuple_type_tail(mi.specTypes)), ' ' => ""))
end

function define_function!(ir::IR, cfg::CFG, variables::Dictionary{Int,Variable})
  argtypes = SPIRType[]
  global_vars = SSAValue[]
  (; mi) = cfg

  for (i, t) in enumerate(mi.specTypes.types[2:end])
    type = spir_type(t, ir; wrap_mutable = true)
    var = get(variables, i, nothing)
    @switch var begin
      @case ::Nothing
      push!(argtypes, type)
      @case ::Variable
      @switch var.storage_class begin
        @case &StorageClassFunction
        push!(argtypes, type)
        @case ::StorageClass
        push!(global_vars, emit!(ir, var))
      end
    end
  end
  ci = cfg.interp.global_cache[mi]
  ftype = FunctionType(spir_type(ci.rettype, ir), argtypes)
  FunctionDefinition(ftype, FunctionControlNone, [], [], SSADict(), global_vars)
end

function emit!(ir::IR, fdef::FunctionDefinition)
  emit!(ir, fdef.type)
  fid = next!(ir.ssacounter)
  append!(fdef.args, next!(ir.ssacounter) for _ = 1:length(fdef.type.argtypes))
  insert!(ir.fdefs, fid, fdef)
  fid
end

emit!(ir::IR, irmap::IRMapping, c::Constant) = emit!(ir, c)
emit!(ir::IR, irmap::IRMapping, @nospecialize(type::SPIRType)) = emit!(ir, type)

function emit!(ir::IR, @nospecialize(type::SPIRType))
  haskey(ir.types, type) && return ir.types[type]
  @switch type begin
    @case ::PointerType
    emit!(ir, type.type)
    @case (::ArrayType && GuardBy(isnothing ∘ Base.Fix2(getproperty, :size))) || ::VectorType || ::MatrixType
    emit!(ir, type.eltype)
    @case ::ArrayType
    emit!(ir, type.eltype)
    emit!(ir, type.size)
    @case ::StructType
    for t in type.members
      emit!(ir, t)
    end
    @case ::ImageType
    emit!(ir, type.sampled_type)
    @case ::SampledImageType
    emit!(ir, type.image_type)
    @case ::VoidType || ::IntegerType || ::FloatType || ::BooleanType || ::OpaqueType || ::SamplerType
    next!(ir.ssacounter)
    @case ::FunctionType
    emit!(ir, type.rettype)
    for t in type.argtypes
      emit!(ir, t)
    end
  end

  id = next!(ir.ssacounter)
  insert!(ir.types, id, type)
  id
end

function emit!(ir::IR, c::Constant)
  haskey(ir.constants, c) && return ir.constants[c]
  emit!(ir, SPIRType(c, ir))
  id = next!(ir.ssacounter)
  insert!(ir.constants, id, c)
  id
end

function emit!(ir::IR, var::Variable)
  haskey(ir.global_vars, var) && return ir.global_vars[var]
  emit!(ir, var.type)
  id = next!(ir.ssacounter)
  insert!(ir.global_vars, id, var)
  id
end

function emit!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, cfg::CFG)
  ranges = block_ranges(cfg)
  graph, backedges = remove_backedges(cfg.graph)
  nodelist = traverse(graph; has_backedges = false)
  add_mapping!(irmap, ir, ranges, nodelist)
  emit_nodes!(fdef, ir, irmap, cfg, ranges, nodelist, backedges)
  replace_forwarded_ssa!(fdef, irmap)
end

function add_mapping!(irmap::IRMapping, ir::IR, ranges, nodelist)
  for node in nodelist
    id = next!(ir.ssacounter)
    insert!(irmap.bbs, node, id)
    insert!(irmap.bb_ssavals, Core.SSAValue(first(ranges[node])), id)
  end
end

function emit_nodes!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, cfg::CFG, ranges, nodelist, backedges)
  for node in nodelist
    emit!(fdef, ir, irmap, cfg, ranges[node], node)
    ins = inneighbors(cfg.graph, node)
    outs = outneighbors(cfg.graph, node)
    local_backedges = filter(in(backedges), map(Base.Fix2(Edge, node), ins))
    if !isempty(local_backedges)
      # Must be a loop.
      if length(local_backedges) > 1
        throw(CompilationError("There is more than one backedge to a loop."))
      end
      vcont = only(local_backedges)
      vmerge = nothing
      vmerge_candidates = findall(v -> !has_path(cfg.graph, v, node), outs)
      @switch length(vmerge_candidates) begin
        @case 0
        throw(CompilationError("No merge candidate found for a loop."))
        @case 1
        vmerge = outs[only(vmerge_candidates)]
        @case GuardBy(>(1))
        throw(CompilationError("More than one candidates found for a loop."))
      end
      header = @inst OpLoopMerge(irmap.bbs[vmerge], irmap.bbs[vcont], SelectionControlNone)
      block = last(fdef.blocks)
      insert!(block.insts, lastindex(block.insts), header)
    elseif length(outs) > 1
      # We're branching.
      vmerge = postdominator(cfg, node)
      merge_id = if isnothing(vmerge)
        # All target blocks return.
        # Any block is valid in that case.
        irmap.bbs[last(outs)]
      else
        irmap.bbs[vmerge]
      end
      header = @inst OpSelectionMerge(merge_id, SelectionControlNone)
      block = last(fdef.blocks)
      insert!(block.insts, lastindex(block.insts), header)
    end
  end
end

function remove_backedges!(g::AbstractGraph, source)
  dfs = dfs_tree(g, source)
  visited = Int[]
  backedges = Edge{Int}[]
  for v in 1:nv(dfs)
    push!(visited, v)
    for dst in outneighbors(g, v)
      if in(dst, visited)
        rem_edge!(g, v, dst)
        push!(backedges, Edge(v, dst))
      end
    end
  end
  g, backedges
end
remove_backedges(g::AbstractGraph, source = 1) = remove_backedges!(deepcopy(g), source)

function traverse(g::AbstractGraph, source = 1; has_backedges = true)
  has_backedges && (g = first(remove_backedges(g, source)))
  topological_sort_by_dfs(g)
end
traverse(cfg::CFG) = traverse(cfg.graph)

postdominator(cfg::CFG, source) = postdominator(cfg.graph, source)

function postdominator(g::AbstractGraph, source)
  vs = outneighbors(g, source)
  @assert length(vs) > 1
  postdominator!(Int[], vs, g, pop!(vs))
end

function postdominator!(traversed, vs, g::AbstractGraph, i)
  ins = inneighbors(g, i)
  if length(ins) > 1
    if any(!in(traversed), ins)
      if !isempty(vs)
        # Kill the current path and start walking from another path vertex.
        return postdominator!(traversed, vs, g, pop!(vs))
      end
    else
      if isempty(vs)
        # All paths converged to a single vertex.
        return i
      end
    end
  end
  next = filter(!in(traversed), outneighbors(g, i))
  if isempty(next)
    if isempty(vs)
      nothing
    else
      postdominator!(traversed, vs, g, pop!(vs))
    end
  else
    if length(next) > 1
      # Create new path vertices.
      append!(vs, next[2:end])
    end
    push!(traversed, i)
    postdominator!(traversed, vs, g, first(next))
  end
end

"""
Replace forward references to `Core.SSAValue`s by their appropriate `SSAValue`.
"""
function replace_forwarded_ssa!(fdef::FunctionDefinition, irmap::IRMapping)
  for block in fdef.blocks
    for inst in block.insts
      for (i, arg) in enumerate(inst.arguments)
        isa(arg, Core.SSAValue) && (inst.arguments[i] = SSAValue(arg, irmap))
      end
    end
  end
end

function emit!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, cfg::CFG, range::UnitRange, node::Integer)
  (; code, ssavaluetypes, slottypes) = cfg.code
  blk = new_block!(fdef, SSAValue(node, irmap))
  for i in range
    jinst = code[i]
    jtype = ssavaluetypes[i]
    core_ssaval = Core.SSAValue(i)
    spv_inst = nothing
    @assert !(jtype <: Core.IntrinsicFunction) "Encountered illegal core intrinsic $jinst."
    jtype ≠ Union{} || throw(CompilationError("Encountered bottom type $jtype, which may indicate an error in the original code."))
    try
      @switch jinst begin
        @case ::Core.ReturnNode
        spv_inst = @match jinst.val begin
          ::Nothing => @inst OpReturn()
          val => begin
            args = Any[val]
            load_variables!(args, blk, ir, irmap, fdef, OpReturnValue)
            remap_args!(args, ir, irmap, OpReturnValue)
            @inst OpReturnValue(only(args))
          end
        end
        push!(blk, irmap, spv_inst, core_ssaval)
        @case ::Core.GotoNode
        dest = irmap.bb_ssavals[Core.SSAValue(jinst.label)]
        spv_inst = @inst OpBranch(dest)
        push!(blk, irmap, spv_inst, core_ssaval)
        @case ::Core.GotoIfNot
        # Core.GotoIfNot uses the SSA value of the first instruction of the target
        # block as its `dest`.
        dest = irmap.bb_ssavals[Core.SSAValue(jinst.dest)]
        spv_inst = @inst OpBranchConditional(SSAValue(jinst.cond, irmap), SSAValue(node + 1, irmap), dest)
        push!(blk, irmap, spv_inst, core_ssaval)
        @case ::GlobalRef
        jtype <: Type || throw(CompilationError("Unhandled global reference $(repr(jtype))"))
        insert!(irmap.globalrefs, core_ssaval, jinst)
        @case _
        check_isvalid(jtype)
        if ismutabletype(jtype)
          allocate_variable!(ir, irmap, fdef, jtype, core_ssaval)
        end
        ret = emit_inst!(ir, irmap, cfg, fdef, jinst, jtype, blk)
        if isa(ret, Instruction)
          if ismutabletype(jtype)
            # The current core SSAValue has already been assigned (to the variable).
            push!(blk, irmap, ret, nothing)
            # Store to the new variable.
            push!(blk, irmap, @inst OpStore(irmap.ssavals[core_ssaval], ret.result_id::SSAValue))
          else
            push!(blk, irmap, ret, core_ssaval)
          end
        elseif isa(ret, SSAValue)
          # The value is a SPIR-V global (possibly a constant),
          # so no need to push a new function instruction.
          # Just map the current SSA value to the global.
          insert!(irmap.ssavals, core_ssaval, ret)
        end
      end
    catch e
      fields = (; jinst, jtype)
      !isnothing(spv_inst) && (fields = (; fields..., inst = spv_inst))
      throw_compilation_error(e, fields)
    end
  end

  # Implicit `goto` to the next block.
  if !is_termination_instruction(last(blk))
    spv_inst = @inst OpBranch(SSAValue(node + 1, irmap))
    push!(blk, irmap, spv_inst)
  end
end

const termination_instructions = Set([
  OpBranch, OpBranchConditional,
  OpReturn, OpReturnValue,
  OpUnreachable,
  OpKill, OpTerminateInvocation,
])

is_termination_instruction(inst::Instruction) = inst.opcode in termination_instructions

function allocate_variable!(ir::IR, irmap::IRMapping, fdef::FunctionDefinition, jtype::Type, core_ssaval::Core.SSAValue)
  # Create a SPIR-V variable to allow for future mutations.
  id = next!(ir.ssacounter)
  type = PointerType(StorageClassFunction, spir_type(jtype, ir))
  var = Variable(type)
  emit!(ir, type)
  insert!(irmap.variables, core_ssaval, var)
  insert!(irmap.ssavals, core_ssaval, id)
  push!(fdef.local_vars, Instruction(var, id, ir))
end

function Base.push!(block::Block, irmap::IRMapping, inst::Instruction, core_ssaval::Optional{Core.SSAValue} = nothing)
  if !isnothing(inst.result_id) && !isnothing(core_ssaval)
    insert!(irmap.ssavals, core_ssaval, inst.result_id)
  end
  push!(block.insts, inst)
end

function julia_type(@nospecialize(t::SPIRType), ir::IR)
  @match t begin
    &(IntegerType(8, false)) => UInt8
    &(IntegerType(16, false)) => UInt16
    &(IntegerType(32, false)) => UInt32
    &(IntegerType(64, false)) => UInt64
    &(IntegerType(8, true)) => Int8
    &(IntegerType(16, true)) => Int16
    &(IntegerType(32, true)) => Int32
    &(IntegerType(64, true)) => Int64
    &(FloatType(16)) => Float16
    &(FloatType(32)) => Float32
    &(FloatType(64)) => Float64
  end
end

function emit_extinst!(ir::IR, extinst)
  haskey(ir.extinst_imports, extinst) && return ir.extinst_imports[extinst]
  id = next!(ir.ssacounter)
  insert!(ir.extinst_imports, id, extinst)
  id
end

function check_isvalid(jtype::Type)
  if !in(jtype, spirv_types)
    if isabstracttype(jtype)
      throw(CompilationError("Found abstract type '$jtype' after type inference. All types must be concrete."))
    elseif !isconcretetype(jtype)
      throw(CompilationError("Found non-concrete type '$jtype' after type inference. All types must be concrete."))
    end
  end
end

macro compile(features, interp, ex)
  compile_args = map(esc, get_signature(ex))
  :(compile($(compile_args...), $(esc(features)); interp = $interp))
end

macro compile(interp, ex)
  esc(:($(@__MODULE__).@compile $(AllSupported()) $interp $ex))
end
macro compile(ex)
  esc(:($(@__MODULE__).@compile $(AllSupported()) $(SPIRVInterpreter()) $ex))
end
