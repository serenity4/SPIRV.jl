    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:inferred, :interp), Tuple{Bool, SPIRVInterpreter}},Type{SPIRVTarget},Any,Type})   # time: 1.1861275
    Base.precompile(Tuple{typeof(+),Vec{3, Float64},Vec{3, Float64}})   # time: 1.0534562
    Base.precompile(Tuple{typeof(getproperty),Vec2,Symbol})   # time: 0.97091216
    Base.precompile(Tuple{typeof(satisfy_requirements!),IR,AllSupported})   # time: 0.6252749
    Base.precompile(Tuple{Core.kwftype(typeof(compile)),NamedTuple{(:interp,), Tuple{SPIRVInterpreter}},typeof(compile),Any,Any,AllSupported})   # time: 0.47735065
    Base.precompile(Tuple{typeof(annotate),Module})   # time: 0.37583783
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:satisfy_requirements,), Tuple{Bool}},Type{IR},Module})   # time: 0.34373584
    Base.precompile(Tuple{typeof(interpret),Function,Vararg{Any}})   # time: 0.3059984
    Base.precompile(Tuple{typeof(restructure_merge_blocks!),IR})   # time: 0.29325923
    Base.precompile(Tuple{typeof(cyclic_region),DeltaGraph{Int64},Int64})   # time: 0.29036006
    Base.precompile(Tuple{typeof(renumber_ssa),Module})   # time: 0.28814927
    Base.precompile(Tuple{typeof(generate_ir),Expr})   # time: 0.2781558
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,MemoryAccess,OperandInfo})   # time: 0.25693017
    Base.precompile(Tuple{typeof(acyclic_region),DeltaGraph{Int64},Int64})   # time: 0.24090199
    Base.precompile(Tuple{Type{ControlTree},DeltaGraph{Int64}})   # time: 0.23823904
    Base.precompile(Tuple{typeof(merge),Decorations,Decorations})   # time: 0.229039
    Base.precompile(Tuple{typeof(add_merge_headers!),IR})   # time: 0.20556992
    Base.precompile(Tuple{typeof(validate),IR})   # time: 0.18100949
    Base.precompile(Tuple{typeof(dependent_functions),IR,ResultID})   # time: 0.1778569
    Base.precompile(Tuple{typeof(read),IOBuffer,Type{PhysicalModule}})   # time: 0.17419446
    Base.precompile(Tuple{typeof(append_decorations!),Vector{Instruction},ResultID,Decorations})   # time: 0.1647065
    Base.precompile(Tuple{typeof(show),IOBuffer,MIME{Symbol("text/plain")},Module})   # time: 0.16034858
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:memory_model,), Tuple{MemoryModel}},Type{IR}})   # time: 0.15418702
    Base.precompile(Tuple{Type{Shader},SPIRVTarget,ShaderInterface})   # time: 0.15186279
    Base.precompile(Tuple{typeof(show),IOBuffer,MIME{Symbol("text/plain")},IR})   # time: 0.14396188
    Base.precompile(Tuple{typeof(read),Type{Module},String})   # time: 0.11988096
    Base.precompile(Tuple{typeof(validate),Module})   # time: 0.11813329
    Base.precompile(Tuple{Type{UseDefChain},AnnotatedModule,AnnotatedFunction,ResultID,StackTrace})   # time: 0.11793347
    Base.precompile(Tuple{typeof(extract_bytes),Vec{2, Int16}})   # time: 0.09690456
    Base.precompile(Tuple{typeof(add_type_layouts!),TypeMetadata,VulkanLayout})   # time: 0.09635715
    Base.precompile(Tuple{Type{Module},String})   # time: 0.09624471
    Base.precompile(Tuple{Type{EdgeClassification},DeltaGraph{Int64}})   # time: 0.089247294
    Base.precompile(Tuple{Type{TypeInfo},Vector{DataType},VulkanLayout})   # time: 0.086249374
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Capability,Type})   # time: 0.08477622
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, Constant}})   # time: 0.084184505
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,FunctionControl,Type})   # time: 0.07653404
    Base.precompile(Tuple{typeof(format_parameter),OperandInfo})   # time: 0.07503114
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(/),Float64,Vec{2, UInt32}})   # time: 0.070721686
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,SelectionControl,Type})   # time: 0.06708892
    Base.precompile(Tuple{typeof(isapprox),Module,Module})   # time: 0.0666936
    Base.precompile(Tuple{typeof(edges),DeltaGraph{Int64}})   # time: 0.061757796
    Base.precompile(Tuple{typeof(sin),Float32})   # time: 0.05939342
    Base.precompile(Tuple{typeof(align),Vector{UInt8},DataType,TypeMetadata})   # time: 0.05895046
    Base.precompile(Tuple{typeof(exp),Float32})   # time: 0.058820996
    Base.precompile(Tuple{Type{FeatureRequirements},Vector{Instruction},AllSupported})   # time: 0.05653013
    Base.precompile(Tuple{typeof(merge_vertices!),DeltaGraph{Int64},Int64,Int64,Int64})   # time: 0.05642215
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Dim,Type})   # time: 0.056026623
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,AddressingModel,Type})   # time: 0.055699676
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ExecutionMode,Type})   # time: 0.055501908
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Decoration,Type})   # time: 0.055026803
    Base.precompile(Tuple{typeof(compact),DeltaGraph{Int64}})   # time: 0.05435058
    Base.precompile(Tuple{typeof(CompositeConstruct),Type{Mat4},Vec4,Vec4,Vec4,Vec4})   # time: 0.05394668
    Base.precompile(Tuple{typeof(show),IOContext{IOBuffer},ControlTree})   # time: 0.05325731
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,LoopControl,Type})   # time: 0.05111756
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, PointerType}})   # time: 0.050546907
    Base.precompile(Tuple{typeof(sinks),DeltaGraph{Int64}})   # time: 0.049712084
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ResultID,Id})   # time: 0.049041864
    Base.precompile(Tuple{typeof(reinterpret_spirv),Type,Vector{UInt8}})   # time: 0.048117016
    Base.precompile(Tuple{typeof(isapprox),PhysicalModule,PhysicalModule})   # time: 0.044502992
    let fbody = try Base.bodyfunction(which(spir_type, (DataType,TypeMap,))) catch missing end
    if !ismissing(fbody)
        precompile(fbody, (Bool,Nothing,typeof(spir_type),DataType,TypeMap,))
    end
end   # time: 0.04247077
    Base.precompile(Tuple{Type{Expression},OpCode,ArrayType,ResultID,ResultID,Vararg{ResultID}})   # time: 0.042279232
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,BuiltIn,Type})   # time: 0.042264402
    Base.precompile(Tuple{typeof(extract_bytes),Vec{2, Int64}})   # time: 0.042228796
    Base.precompile(Tuple{typeof(merge_blocks),FunctionDefinition})   # time: 0.041564472
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ExecutionModel,Type})   # time: 0.04143617
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,MemoryModel,Type})   # time: 0.04121457
    Base.precompile(Tuple{typeof(postdominator),ControlFlowGraph{Graphs.SimpleGraphs.SimpleEdge{Int64}, Int64, DeltaGraph{Int64}},Int64})   # time: 0.040934656
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,SourceLanguage,Type})   # time: 0.040338103
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ImageFormat,Type})   # time: 0.039959818
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,StorageClass,Type})   # time: 0.03982628
    let fbody = try Base.bodyfunction(which(spir_type, (DataType,Nothing,))) catch missing end
    if !ismissing(fbody)
        precompile(fbody, (Bool,Nothing,typeof(spir_type),DataType,Nothing,))
    end
end   # time: 0.03776058
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.03726042
    Base.precompile(Tuple{typeof(rem_vertex!),DeltaGraph{Int64},Int64})   # time: 0.035850942
    Base.precompile(Tuple{typeof(convert),Type{Vec{2, Int16}},Vec{2, Int64}})   # time: 0.035530373
    Base.precompile(Tuple{typeof(decorate!),Decorations,Decoration,Int64})   # time: 0.0341151
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,ResultID,Float32})   # time: 0.033804998
    Base.precompile(Tuple{typeof(compute_stride),StructType,TypeMetadata,VulkanLayout})   # time: 0.033404987
    Base.precompile(Tuple{Type{DeltaGraph}})   # time: 0.03173273
    Base.precompile(Tuple{typeof(align),Vector{UInt8},StructType,TypeMetadata})   # time: 0.030420912
    Base.precompile(Tuple{typeof(log),Float32})   # time: 0.030350043
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, FunctionType}})   # time: 0.030260356
    Base.precompile(Tuple{Type{Vec4},Int64,Vararg{Int64}})   # time: 0.029676927
    Base.precompile(Tuple{typeof(getproperty),Vec4,Symbol})   # time: 0.028944988
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},AddressingModel})   # time: 0.028214803
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,UInt32,Literal})   # time: 0.027501099
    Base.precompile(Tuple{SampledImage{Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4}},Vec2})   # time: 0.026668876
    Base.precompile(Tuple{Type{Expression},OpCode,FloatType,ResultID,Core.SSAValue,Vararg{Any}})   # time: 0.026598822
    Base.precompile(Tuple{typeof(parse),Type{Module},String})   # time: 0.026493222
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SourceLanguage,Vararg{Any}})   # time: 0.026373677
    Base.precompile(Tuple{typeof(getindex),Arr{5, Float32},UInt32})   # time: 0.026137711
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,StructType,Set{Any},Bool})   # time: 0.026091117
    Base.precompile(Tuple{typeof(reinterpret_spirv),Type{Vector{Vec{2, Int64}}},AbstractArray{UInt8}})   # time: 0.025682712
    Base.precompile(Tuple{typeof(align),Vector{UInt8},Vector{Int64},Vector{Int64}})   # time: 0.025530634
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,Nothing,ResultID,Vararg{Any}})   # time: 0.025241558
    Base.precompile(Tuple{typeof(extract_bytes),Int8})   # time: 0.025019297
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, ArrayType}})   # time: 0.024976766
    Base.precompile(Tuple{Type{StructType},Vector{IntegerType}})   # time: 0.024956942
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, ImageType}})   # time: 0.024913806
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,ResultID,FunctionControl,Vararg{Any}})   # time: 0.024759283
    Base.precompile(Tuple{Type{SPIRVInterpreter}})   # time: 0.023183785
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},String})   # time: 0.022397911
    Base.precompile(Tuple{typeof(emit_expression!),ModuleTarget,Translation,SPIRVTarget,FunctionDefinition,Expr,Type,Block})   # time: 0.022081466
    Base.precompile(Tuple{Type{ShaderInterface},ExecutionModel,Vector{StorageClass}})   # time: 0.021914538
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, Variable}})   # time: 0.021911178
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec3,Vec3})   # time: 0.020899883
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,FunctionControl,OperandInfo})   # time: 0.020822667
    Base.precompile(Tuple{typeof(getindex),Pointer{Tuple{Int64, Int64, Int64}},Int64})   # time: 0.02069287
    Base.precompile(Tuple{typeof(decorate!),Metadata,Int64,Decoration,Int64})   # time: 0.01829519
    Base.precompile(Tuple{typeof(emit_expression!),ModuleTarget,Translation,SPIRVTarget,FunctionDefinition,Core.PhiNode,Type,Block})   # time: 0.017966144
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec3,Float32})   # time: 0.017675197
    Base.precompile(Tuple{typeof(flow_through),Function,ControlFlowGraph{Graphs.SimpleGraphs.SimpleEdge{Int64}, Int64, DeltaGraph{Int64}},Int64})   # time: 0.017597804
    Base.precompile(Tuple{typeof(emit_nodes!),FunctionDefinition,ModuleTarget,Translation,SPIRVTarget,Vector{UnitRange{Int64}},Vector{Int64},Set{Graphs.SimpleGraphs.SimpleEdge{Int64}}})   # time: 0.017430583
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec2,Vec{2, Int64}})   # time: 0.017136207
    Base.precompile(Tuple{typeof(extract_bytes),Mat4})   # time: 0.01704785
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,StructType,Vector{StorageClass},Bool})   # time: 0.016988603
    Base.precompile(Tuple{typeof(satisfy_requirements!),IR,SupportedFeatures})   # time: 0.016725704
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ImageOperands,OperandInfo})   # time: 0.016694201
    Base.precompile(Tuple{typeof(append_debug_annotations!),Vector{Instruction},ResultID,Metadata})   # time: 0.01659015
    Base.precompile(Tuple{typeof(extract_bytes),Vector{Vec{2, Int64}}})   # time: 0.01629493
    Base.precompile(Tuple{typeof(getproperty),Vec{4, Float64},Symbol})   # time: 0.016198292
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(+),Vec2,Vec2})   # time: 0.016126523
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,ResultID,Int32})   # time: 0.015721291
    Base.precompile(Tuple{typeof(getindex),Mat{4, 4, Float64},Int64,Int64})   # time: 0.015537635
    Base.precompile(Tuple{typeof(promote_to_interface_block),SampledImageType,StorageClass})   # time: 0.01514258
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,ResultID,ResultID,Vararg{ResultID}})   # time: 0.014875737
    Base.precompile(Tuple{typeof(==),PhysicalModule,PhysicalModule})   # time: 0.014411505
    Base.precompile(Tuple{typeof(similar),Mat{2, 2, Float64}})   # time: 0.014160836
    Base.precompile(Tuple{typeof(decorate!),Decorations,Decoration,Int64,Int64,Int64})   # time: 0.01390908
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,LoopControl,OperandInfo})   # time: 0.013832925
    Base.precompile(Tuple{typeof(getindex),Mat{2, 2, Float64},Int64,Int64})   # time: 0.013752645
    Base.precompile(Tuple{typeof(nexs),FunctionDefinition})   # time: 0.013561457
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,SelectionControl,OperandInfo})   # time: 0.013548927
    Base.precompile(Tuple{typeof(reinterpret_spirv),Type{Vec{2, Int64}},AbstractArray{UInt8}})   # time: 0.013454403
    Base.precompile(Tuple{typeof(==),AnnotatedFunction,AnnotatedFunction})   # time: 0.013193974
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},FunctionControl})   # time: 0.013019337
    Base.precompile(Tuple{Type{FunctionType},FloatType,Vector{BooleanType}})   # time: 0.013006832
    Base.precompile(Tuple{typeof(add_align_operands!),IR,FunctionDefinition,VulkanLayout})   # time: 0.012920886
    isdefined(SPIRV, Symbol("#320#323")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#320#323")),Vector{Float64}})   # time: 0.012771465
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,String,Literal})   # time: 0.012766745
    Base.precompile(Tuple{Type{StructType},Vector{ScalarType}})   # time: 0.012735148
    Base.precompile(Tuple{Type{Arr{Float32}},Float64,Float64,Float64,Float64,Float64})   # time: 0.012522649
    Base.precompile(Tuple{typeof(size),Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4},Int64})   # time: 0.012319053
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, FloatType}})   # time: 0.012294352
    Base.precompile(Tuple{typeof(reinterpret_spirv),Type{Vector{Vec{2, Int64}}},Vector{UInt8}})   # time: 0.012228682
    Base.precompile(Tuple{typeof(extract_bytes),Int32})   # time: 0.012216244
    Base.precompile(Tuple{Type{StructType},Vector{MatrixType}})   # time: 0.012124251
    Base.precompile(Tuple{typeof(common_ancestor),DominatorTree,Vector{DominatorTree}})   # time: 0.01181152
    Base.precompile(Tuple{Type{StructType},Vector{FloatType}})   # time: 0.011810029
    Base.precompile(Tuple{typeof(nesting_levels),ControlTree})   # time: 0.011726632
    isdefined(SPIRV, Symbol("#320#323")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#320#323")),Vector{Int64}})   # time: 0.011609933
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,ResultID,Int64,Vararg{Int64}})   # time: 0.011462343
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},MemoryAccess})   # time: 0.011204409
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, VectorType}})   # time: 0.011180767
    Base.precompile(Tuple{typeof(getindex),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Int64,Int64})   # time: 0.011168792
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},OpCodeGLSL})   # time: 0.011129963
    Base.precompile(Tuple{typeof(extract_bytes),Int64})   # time: 0.01111917
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},SelectionControl})   # time: 0.010997853
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.010804338
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ExecutionModel})   # time: 0.010606639
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ImageFormat})   # time: 0.010552655
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},SourceLanguage})   # time: 0.010535148
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},BuiltIn})   # time: 0.010526809
    Base.precompile(Tuple{Type{FunctionType},VoidType,Vector{PointerType}})   # time: 0.010468982
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ExecutionMode})   # time: 0.010419826
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Decoration})   # time: 0.010410151
    Base.precompile(Tuple{typeof(isapprox),StructType,StructType})   # time: 0.01039574
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},StorageClass})   # time: 0.010386376
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Dim})   # time: 0.010386268
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},LoopControl})   # time: 0.010384321
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},MemoryModel})   # time: 0.010313913
    Base.precompile(Tuple{Type{StructType},Vector{ArrayType}})   # time: 0.010198211
    Base.precompile(Tuple{typeof(get_signature),Expr})   # time: 0.010184724
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Capability})   # time: 0.010040736
    Base.precompile(Tuple{typeof(mod),Float64,Float64})   # time: 0.009939157
    Base.precompile(Tuple{Type{Vec2},Int64,Int64})   # time: 0.00974773
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec{2, Float64},Float32})   # time: 0.009404294
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, StructType}})   # time: 0.009257999
    Base.precompile(Tuple{typeof(validate),Shader})   # time: 0.009256927
    Base.precompile(Tuple{typeof(postdominator),ControlFlowGraph{Graphs.SimpleGraphs.SimpleEdge{Int64}, Int64, SimpleDiGraph{Int64}},Int64})   # time: 0.009016173
    Base.precompile(Tuple{typeof(invalidate_all!),SPIRVInterpreter})   # time: 0.00879349
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.008685923
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.008654764
    Base.precompile(Tuple{typeof(*),Int64,Vec2})   # time: 0.008597053
    Base.precompile(Tuple{typeof(==),FeatureRequirements,FeatureRequirements})   # time: 0.008591439
    Base.precompile(Tuple{typeof(decorate!),Decorations,Decoration,Int64,Int64,Vararg{Int64}})   # time: 0.008484362
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.008426247
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.008414315
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.008310719
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.008310181
    Base.precompile(Tuple{typeof(conflicted_merge_blocks),FunctionDefinition})   # time: 0.008271907
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.008188298
    Base.precompile(Tuple{Type{ControlFlowGraph},DeltaGraph{Int64}})   # time: 0.007911283
    Base.precompile(Tuple{typeof(==),DeltaGraph{Int64},DeltaGraph{Int64}})   # time: 0.007883734
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,StorageClass,OperandInfo})   # time: 0.007784264
    Base.precompile(Tuple{typeof(==),ControlTree,ControlTree})   # time: 0.00777943
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,UInt32,Decoration,UInt32})   # time: 0.007617073
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,IntegerType,Set{Any},Bool})   # time: 0.00761049
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,ResultID,ResultID})   # time: 0.007590357
    Base.precompile(Tuple{Type{StackFrame},AnnotatedModule,ResultID})   # time: 0.007343125
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,Decoration,UInt32})   # time: 0.007101917
    Base.precompile(Tuple{typeof(CompositeConstruct),Type{Mat{3, 4, Float32}},Vec3,Vec3,Vec3,Vec3})   # time: 0.007079307
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,UInt32,Decoration})   # time: 0.006944506
    Base.precompile(Tuple{typeof(getindex),Arr{3, Float64},Int64})   # time: 0.006943368
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,Decoration})   # time: 0.006869864
    Base.precompile(Tuple{typeof(getindex),Mat{3, 4, Float32},Int64,Int64})   # time: 0.006791707
    Base.precompile(Tuple{typeof(parse),Type{SPIRType},Instruction,BijectiveMapping{ResultID, SPIRType},BijectiveMapping{ResultID, Constant}})   # time: 0.006753609
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Vararg{Pair{Int64, Int64}}})   # time: 0.006665469
    Base.precompile(Tuple{Type{SPIRVInterpreter},Vector{Core.MethodTable}})   # time: 0.006390548
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, IntegerType}})   # time: 0.006312908
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Capability,OperandInfo})   # time: 0.006031293
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,FunctionType})   # time: 0.005907007
    Base.precompile(Tuple{typeof(metadata!),TypeMetadata,PointerType})   # time: 0.005790398
    Base.precompile(Tuple{typeof(getindex),Arr{4, Float64},Int64})   # time: 0.005762973
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Decoration,OperandInfo})   # time: 0.005634825
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,BuiltIn,OperandInfo})   # time: 0.005593227
    Base.precompile(Tuple{typeof(backedges),DeltaGraph{Int64}})   # time: 0.005542911
    Base.precompile(Tuple{typeof(append_decorations!),Vector{Instruction},ResultID,Metadata})   # time: 0.005542093
    isdefined(SPIRV, Symbol("#318#321")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#318#321")),Int64})   # time: 0.005503972
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,AddressingModel,OperandInfo})   # time: 0.005332758
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,OpCodeGLSL,OperandInfo})   # time: 0.00532372
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,StructType})   # time: 0.005241453
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,VectorType})   # time: 0.005234512
    Base.precompile(Tuple{typeof(CompositeConstruct),Type{Mat{2, 2, Float64}},Vec{2, Float64},Vec{2, Float64}})   # time: 0.005210426
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,MatrixType})   # time: 0.005172542
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,IntegerType})   # time: 0.005148501
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ResultID,OperandInfo})   # time: 0.005139324
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,ArrayType})   # time: 0.005122446
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,MemoryModel,OperandInfo})   # time: 0.005116206
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,FloatType})   # time: 0.005113593
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Dim,OperandInfo})   # time: 0.005088908
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,SourceLanguage,OperandInfo})   # time: 0.005085686
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ExecutionModel,OperandInfo})   # time: 0.005081508
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,VoidType})   # time: 0.005078054
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ImageFormat,OperandInfo})   # time: 0.005027932
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ExecutionMode,OperandInfo})   # time: 0.005006415
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,ArrayType,Set{Any},Bool})   # time: 0.004869144
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(/),Vec2,Vec{2, Int64}})   # time: 0.004845959
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,UInt32,OperandInfo})   # time: 0.004772557
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(+),Vec3,Vec3})   # time: 0.004765381
    isdefined(SPIRV, Symbol("#callback#312")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#callback#312")),MethodInstance,UInt32})   # time: 0.00475965
    Base.precompile(Tuple{typeof(promote_to_interface_block),VectorType,StorageClass})   # time: 0.004667005
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,VoidType})   # time: 0.004645848
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:storage_classes, :variable_decorations, :type_metadata, :features), Tuple{Vector{StorageClass}, Dictionary{Int64, Decorations}, Dictionary{DataType, Metadata}, SupportedFeatures}},Type{ShaderInterface}})   # time: 0.004611505
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,FloatType})   # time: 0.004603006
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,StructType})   # time: 0.004533874
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:execution_model, :storage_classes, :variable_decorations, :features), Tuple{ExecutionModel, Vector{StorageClass}, Dictionary{Int64, Decorations}, SupportedFeatures}},Type{ShaderInterface}})   # time: 0.004493696
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,ArrayType})   # time: 0.004489599
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,VectorType})   # time: 0.004484296
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,PointerType})   # time: 0.004467224
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:execution_model, :storage_classes, :variable_decorations), Tuple{ExecutionModel, Vector{StorageClass}, Dictionary{Int64, Decorations}}},Type{ShaderInterface}})   # time: 0.004451365
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,BooleanType})   # time: 0.004417245
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,IntegerType})   # time: 0.004415276
    Base.precompile(Tuple{typeof(storage_class),Core.SSAValue,ModuleTarget,Translation,FunctionDefinition})   # time: 0.004376272
    Base.precompile(Tuple{Type{ImageType},Instruction,FloatType})   # time: 0.004353375
    Base.precompile(Tuple{typeof(getoffsets),DataType})   # time: 0.004319218
    Base.precompile(Tuple{typeof(dominators),DeltaGraph{Int64}})   # time: 0.00415784
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Float64,OperandInfo})   # time: 0.004010876
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,IntegerType,Set{StorageClass},Bool})   # time: 0.003979388
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Core.SSAValue,OperandInfo})   # time: 0.003940841
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,SamplerType})   # time: 0.003926387
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,MatrixType})   # time: 0.003915722
    Base.precompile(Tuple{typeof(-),Vec{3, Float64},Vec{3, Float64}})   # time: 0.003913767
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,SampledImageType})   # time: 0.003846837
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,BooleanType})   # time: 0.003834321
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,Variable})   # time: 0.003815605
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Int64,OperandInfo})   # time: 0.003809022
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Int32,OperandInfo})   # time: 0.003756509
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,String,OperandInfo})   # time: 0.003718246
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,Constant})   # time: 0.003713562
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Float32,OperandInfo})   # time: 0.003705753
    Base.precompile(Tuple{typeof(setindex!),Mat{2, 2, Float64},Float64,Int64,Int64})   # time: 0.003701975
    Base.precompile(Tuple{typeof(getoffsets),TypeInfo,DataType})   # time: 0.003668408
    Base.precompile(Tuple{typeof(*),Vec{3, Float64},Vec{3, Float64}})   # time: 0.003647611
    Base.precompile(Tuple{typeof(similar),Arr{4, Float64}})   # time: 0.003552859
    Base.precompile(Tuple{Type{TypeMetadata}})   # time: 0.003550898
    Base.precompile(Tuple{Core.kwftype(typeof(findall)),NamedTuple{(:limit,), Tuple{Int64}},typeof(Core.Compiler.findall),Type{<:Tuple{Any, Bool}},NOverlayMethodTable})   # time: 0.00354772
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,ImageType})   # time: 0.003536754
    Base.precompile(Tuple{Type{Vec{2, UInt32}},Int64,Vararg{Int64}})   # time: 0.0034414
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,ImageType})   # time: 0.003440518
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(-),Vec2,Vec2})   # time: 0.003432391
    Base.precompile(Tuple{typeof(setindex!),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Vec4,Int64,Int64})   # time: 0.003352651
    Base.precompile(Tuple{typeof(getindex),Arr{1, Float32},UInt32})   # time: 0.003341889
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},SamplerType,ResultID})   # time: 0.003258469
    Base.precompile(Tuple{typeof(load_variables!),Vector{ResultID},Block,ModuleTarget,Translation,FunctionDefinition,OpCode})   # time: 0.003229817
    Base.precompile(Tuple{Type{Vec2},Float64,Float64})   # time: 0.003216559
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},SampledImageType,ResultID})   # time: 0.003173007
    Base.precompile(Tuple{Type{Expression},Instruction,BijectiveMapping{ResultID, SPIRType}})   # time: 0.00297974
    Base.precompile(Tuple{Type{VulkanLayout}})   # time: 0.002957529
    Base.precompile(Tuple{typeof(compute_minimal_size),StructType,TypeMetadata,VulkanLayout})   # time: 0.002944092
    Base.precompile(Tuple{Type{ShaderInterface},ExecutionModel,Vector{StorageClass},Dictionary{Int64, Decorations}})   # time: 0.002926021
    Base.precompile(Tuple{typeof(setindex!),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Vec4,Int64})   # time: 0.002921597
    Base.precompile(Tuple{typeof(eachindex),Mat{2, 2, Float64}})   # time: 0.002907538
    Base.precompile(Tuple{typeof(eachindex),Vec{2, Int64}})   # time: 0.0029062
    Base.precompile(Tuple{typeof(image_type),ImageFormat,Dim,Int64,Bool,Bool,Int64})   # time: 0.002868609
    Base.precompile(Tuple{typeof(setindex!),Arr{4, Float64},Int64,Int64})   # time: 0.002819657
    Base.precompile(Tuple{Type{ControlTree},Int64,RegionType,Tuple{ControlTree, ControlTree, ControlTree}})   # time: 0.00277999
    Base.precompile(Tuple{typeof(getindex),Vec{3, Float64},Int64})   # time: 0.002749139
    Base.precompile(Tuple{typeof(getindex),Vec{4, Float64},Int64})   # time: 0.002747096
    Base.precompile(Tuple{typeof(payload_size),DataType})   # time: 0.002722596
    Base.precompile(Tuple{typeof(has_decoration),Decorations,Decoration})   # time: 0.002687247
    Base.precompile(Tuple{typeof(load_expr),Expr})   # time: 0.002648494
    Base.precompile(Tuple{typeof(has_decoration),Metadata,Int64,Decoration})   # time: 0.002633004
    Base.precompile(Tuple{typeof(source_version),SourceLanguage,UInt32})   # time: 0.002628619
    Base.precompile(Tuple{typeof(add_type_layouts!),IR,VulkanLayout})   # time: 0.002600685
    Base.precompile(Tuple{Type{Vec{1, Float64}},Float64})   # time: 0.002561455
    Base.precompile(Tuple{typeof(cap_world),UInt64,UInt32})   # time: 0.002557582
    Base.precompile(Tuple{typeof(remap_args!),Vector{ResultID},ModuleTarget,Translation,OpCode})   # time: 0.002505879
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,MatrixType,Set{Any},Bool})   # time: 0.002420142
    Base.precompile(Tuple{Type{SimpleTree},DominatorNode,DominatorTree,Vector{DominatorTree}})   # time: 0.002290822
    Base.precompile(Tuple{typeof(getindex),Pointer{Vector{Int64}},Int64})   # time: 0.002260169
    Base.precompile(Tuple{Type{SimpleTree},ControlNode,ControlTree,Vector{ControlTree}})   # time: 0.002259177
    Base.precompile(Tuple{typeof(get),BijectiveMapping{ResultID, SPIRType},IntegerType,Nothing})   # time: 0.002147897
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},SampledImageType})   # time: 0.002068812
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},SamplerType})   # time: 0.002064934
    Base.precompile(Tuple{typeof(setindex!),Mat{2, 2, Float64},Mat{2, 2, Float64}})   # time: 0.002055964
    Base.precompile(Tuple{Type{StructType},Vector{SPIRType}})   # time: 0.002041085
    Base.precompile(Tuple{SampledImage{Image{ImageFormatR16f, Dim2D, 0, false, false, 1, Float32}},Vec2})   # time: 0.002032623
    Base.precompile(Tuple{typeof(merge),Metadata,Metadata})   # time: 0.001977132
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,FloatType,Set{Any},Bool})   # time: 0.001934721
    Base.precompile(Tuple{typeof(==),Module,Module})   # time: 0.001928881
    isdefined(SPIRV, Symbol("#100#101")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#100#101")),Tuple{ResultID, SampledImageType}})   # time: 0.001923647
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,StructType,Set{StorageClass},Bool})   # time: 0.001922203
    isdefined(SPIRV, Symbol("#383#394")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#383#394")),Expr})   # time: 0.001889168
    Base.precompile(Tuple{typeof(Base.Broadcast.materialize!),Vec3,Broadcasted{BroadcastStyleSPIRV{Vec3}, Tuple{Base.OneTo{Int64}}, typeof(identity), Tuple{Vec3}}})   # time: 0.001865457
    isdefined(SPIRV, Symbol("#94#95")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#94#95")),MatrixType})   # time: 0.001851426
    Base.precompile(Tuple{typeof(copyto!),Vec2,Vec2})   # time: 0.001834111
    Base.precompile(Tuple{Type{IntegerType},UInt32,UInt32})   # time: 0.001826169
    isdefined(SPIRV, Symbol("#100#101")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#100#101")),Tuple{ResultID, SamplerType}})   # time: 0.001789482
    Base.precompile(Tuple{typeof(promote_to_interface_block),FloatType,StorageClass})   # time: 0.001787023
    Base.precompile(Tuple{SampledImage{Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4}},Float32,Float32})   # time: 0.001784924
    isdefined(SPIRV, Symbol("#94#95")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#94#95")),ArrayType})   # time: 0.001771158
    isdefined(SPIRV, Symbol("#100#101")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#100#101")),Tuple{ResultID, StructType}})   # time: 0.001628273
    Base.precompile(Tuple{typeof(promote_to_interface_block),IntegerType,StorageClass})   # time: 0.001604753
    Base.precompile(Tuple{typeof(setindex!),Vec{4, Float64},Vec{4, Float64}})   # time: 0.00159831
    Base.precompile(Tuple{typeof(getindex),BijectiveMapping{ResultID, SPIRType},StructType})   # time: 0.001592629
    Base.precompile(Tuple{typeof(setindex!),Arr{4, Float64},Arr{4, Float64}})   # time: 0.001589786
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},FloatType})   # time: 0.001570722
    Base.precompile(Tuple{typeof(align),Vector{UInt8},StructType,Vector{Int64}})   # time: 0.001557676
    isdefined(SPIRV, Symbol("#100#101")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#100#101")),Tuple{ResultID, ImageType}})   # time: 0.00154518
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, MatrixType}})   # time: 0.001514533
    Base.precompile(Tuple{typeof(setindex!),Vec4,Vec4})   # time: 0.001505049
    isdefined(SPIRV, Symbol("#100#101")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#100#101")),Tuple{ResultID, PointerType}})   # time: 0.001481545
    Base.precompile(Tuple{typeof(ConvertUToPtr),Type,UInt64})   # time: 0.001464182
    Base.precompile(Tuple{typeof(clamp),Float32,Float32,Float32})   # time: 0.001450471
    isdefined(SPIRV, Symbol("#118#119")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#118#119")),ResultID})   # time: 0.001436427
    Base.precompile(Tuple{typeof(eachindex),Arr{5, Float32}})   # time: 0.001423689
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},VectorType})   # time: 0.001413055
    Base.precompile(Tuple{typeof(setproperty!),Vec4,Symbol,UInt32})   # time: 0.001412306
    Base.precompile(Tuple{typeof(getindex),BijectiveMapping{ResultID, SPIRType},VoidType})   # time: 0.001409382
    Base.precompile(Tuple{Type{Pointer},Base.RefValue{Tuple{Int64, Int64, Int64}}})   # time: 0.001394773
    Base.precompile(Tuple{typeof(clamp),Float64,Float64,Float64})   # time: 0.001373865
    isdefined(SPIRV, Symbol("#102#103")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#102#103")),Pair{ResultID, VoidType}})   # time: 0.001372251
    Base.precompile(Tuple{Type{Decorations}})   # time: 0.001346784
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,String})   # time: 0.001308135
    Base.precompile(Tuple{typeof(storage_class),Core.Argument,ModuleTarget,Translation,FunctionDefinition})   # time: 0.001303892
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},UInt32})   # time: 0.001284629
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},BooleanType})   # time: 0.001274495
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,UInt32,String})   # time: 0.001263927
    Base.precompile(Tuple{typeof(load_if_variable!),Block,ModuleTarget,Translation,FunctionDefinition,Core.SSAValue})   # time: 0.001210662
    Base.precompile(Tuple{typeof(==),Instruction,Instruction})   # time: 0.001209338
    isdefined(SPIRV, Symbol("#262#267")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#262#267")),Int64})   # time: 0.001198198
    Base.precompile(Tuple{Type{Expression},OpCode,MatrixType,ResultID,ResultID})   # time: 0.001169632
    Base.precompile(Tuple{typeof(getoffsets!),Vector{UInt32},UInt64,typeof(fieldoffset),Type})   # time: 0.001129737
    Base.precompile(Tuple{Type{ImageType},FloatType,Dim,UInt32,UInt32,UInt32,Bool,ImageFormat,Nothing})   # time: 0.001094505
    Base.precompile(Tuple{typeof(decorations),TypeMetadata,ArrayType})   # time: 0.001074226
    Base.precompile(Tuple{SampledImage{Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4}},Float32,Float32})   # time: 0.001070695
    Base.precompile(Tuple{Type{Expression},OpCode,IntegerType,ResultID,ResultID})   # time: 0.001058796
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},ImageType})   # time: 0.001054841
    Base.precompile(Tuple{Type{Expression},OpCode,PointerType,ResultID,ResultID,Vararg{ResultID}})   # time: 0.001030583
    Base.precompile(Tuple{typeof(load_if_variable!),Block,ModuleTarget,Translation,FunctionDefinition,Core.Argument})   # time: 0.001029737
    Base.precompile(Tuple{Type{Expression},OpCode,BooleanType,ResultID,ResultID,Vararg{ResultID}})   # time: 0.00102793
    Base.precompile(Tuple{typeof(decorate!),IR,ResultID,Decoration,UInt32})   # time: 0.00102752
    isdefined(SPIRV, Symbol("#100#101")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#100#101")),Tuple{ResultID, FloatType}})   # time: 0.001020323
    isdefined(SPIRV, Symbol("#14#15")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#14#15")),Tuple{ArrayType, ArrayType}})   # time: 0.001020127
    isdefined(SPIRV, Symbol("#100#101")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#100#101")),Tuple{ResultID, IntegerType}})   # time: 0.001012073
    Base.precompile(Tuple{Type{Expression},OpCode,StructType,ResultID,ResultID,Vararg{ResultID}})   # time: 0.001003759
    isdefined(SPIRV, Symbol("#96#97")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#96#97")),SamplerType})   # time: 0.001003506
