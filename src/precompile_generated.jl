    Base.precompile(Tuple{typeof(+),Vec{3, Float64},Vec{3, Float64}})   # time: 2.1449165
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:inferred, :interp), Tuple{Bool, SPIRVInterpreter}},Type{SPIRVTarget},Any,Type})   # time: 1.5137424
    Base.precompile(Tuple{typeof(acyclic_region),DeltaGraph{Int64},Int64})   # time: 1.2065501
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:interp,), Tuple{SPIRVInterpreter}},typeof(compile),Any,Any,AllSupported})   # time: 0.8474841
    Base.precompile(Tuple{typeof(satisfy_requirements!),IR,AllSupported})   # time: 0.642026
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:satisfy_requirements,), Tuple{Bool}},Type{IR},Module})   # time: 0.58354944
    Base.precompile(Tuple{typeof(annotate),Module})   # time: 0.46529242
    Base.precompile(Tuple{typeof(promote_to_interface_block),SampledImageType,StorageClass})   # time: 0.44266462
    Base.precompile(Tuple{typeof(sin),Float32})   # time: 0.4303311
    Base.precompile(Tuple{typeof(renumber_ssa),Module})   # time: 0.42425898
    Base.precompile(Tuple{typeof(interpret),Function,Vararg{Any}})   # time: 0.41341922
    Base.precompile(Tuple{typeof(*),Vec2,Float32})   # time: 0.38055432
    Base.precompile(Tuple{typeof(==),Vec{2, Int32},Vec2})   # time: 0.37066913
    Base.precompile(Tuple{typeof(cyclic_region),DeltaGraph{Int64},Int64})   # time: 0.3674796
    Base.precompile(Tuple{typeof(read),Type{Module},String})   # time: 0.36503908
    Base.precompile(Tuple{typeof(restructure_merge_blocks!),IR})   # time: 0.36336225
    Base.precompile(Tuple{typeof(merge),Decorations,Decorations})   # time: 0.36292443
    Base.precompile(Tuple{Type{ControlTree},DeltaGraph{Int64}})   # time: 0.35505286
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec{2, Float64},Float32})   # time: 0.3441501
    Base.precompile(Tuple{typeof(getindex),Arr{4, Float64},UInt32})   # time: 0.32969177
    Base.precompile(Tuple{typeof(deserialize),Type{Mat4},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.30219328
    Base.precompile(Tuple{typeof(spir_type),DataType,TypeMap})   # time: 0.2722128
    Base.precompile(Tuple{typeof(datasize),NoPadding,Type{Vec3}})   # time: 0.26070464
    Base.precompile(Tuple{typeof(generate_ir),Expr})   # time: 0.25759274
    Base.precompile(Tuple{Type{VulkanLayout},Vector{DataType}})   # time: 0.25244847
    Base.precompile(Tuple{typeof(serialize),Vector{Arr{2, UInt8}},NativeLayout})   # time: 0.23368752
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, Constant}})   # time: 0.21903574
    Base.precompile(Tuple{typeof(dependent_functions),IR,ResultID})   # time: 0.21210119
    Base.precompile(Tuple{typeof(show),IOBuffer,MIME{Symbol("text/plain")},Module})   # time: 0.19356732
    Base.precompile(Tuple{typeof(read),IOBuffer,Type{PhysicalModule}})   # time: 0.1900757
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,String,Literal})   # time: 0.18805777
    Base.precompile(Tuple{Type{UseDefChain},AnnotatedModule,AnnotatedFunction,ResultID,StackTrace})   # time: 0.16414867
    Base.precompile(Tuple{typeof(emit_constant!),ModuleTarget,Translation,Tuple{Float64, Tuple{UInt32, Int64}}})   # time: 0.1622477
    Base.precompile(Tuple{typeof(append_decorations!),Vector{Instruction},ResultID,Decorations})   # time: 0.15318824
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, UInt32}},Vector{UInt8},NoPadding})   # time: 0.15300412
    Base.precompile(Tuple{Type{Module},String})   # time: 0.15048805
    Base.precompile(Tuple{Type{Shader},SPIRVTarget,ShaderInterface,VulkanAlignment})   # time: 0.12823956
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, Vec3}},Vector{UInt8},NativeLayout})   # time: 0.12275458
    Base.precompile(Tuple{Type{ExplicitLayout},NativeLayout,Vector{DataType}})   # time: 0.12156865
    Base.precompile(Tuple{typeof(==),Vec3,Vec3})   # time: 0.11422481
    Base.precompile(Tuple{Type{ModuleTarget}})   # time: 0.114053346
    Base.precompile(Tuple{typeof(deserialize),Type{Mat{2, 3, Float32}},Vector{UInt8},VulkanLayout})   # time: 0.10801705
    Base.precompile(Tuple{typeof(deserialize),Type{Mat{2, 5, Float32}},Vector{UInt8},VulkanLayout})   # time: 0.103730075
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},SampledImageType})   # time: 0.10289829
    Base.precompile(Tuple{typeof(deserialize),Type{Base.RefValue{Vec4}},Vector{UInt8},NativeLayout})   # time: 0.100749925
    Base.precompile(Tuple{typeof(validate),Module})   # time: 0.09886374
    Base.precompile(Tuple{typeof(deepcopy),Vec2})   # time: 0.09882359
    Base.precompile(Tuple{typeof(isapprox),Module,Module})   # time: 0.09725195
    Base.precompile(Tuple{typeof(deserialize),Type{Base.RefValue{Vec4}},Vector{UInt8},NoPadding})   # time: 0.095764205
    Base.precompile(Tuple{var"##s645#322",Any,Any,Any,Any})   # time: 0.09397204
    Base.precompile(Tuple{Type{FeatureRequirements},Vector{Instruction},AllSupported})   # time: 0.09327775
    Base.precompile(Tuple{typeof(add_options!),EntryPoint,GeometryExecutionOptions})   # time: 0.09310356
    Base.precompile(Tuple{typeof(==),Vec{3, Float64},Vec{3, Float64}})   # time: 0.0921099
    Base.precompile(Tuple{typeof(copy),Pointer{Tuple{Int64, Vec2}}})   # time: 0.09192988
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),Type{Int32},Vec2})   # time: 0.09066481
    Base.precompile(Tuple{typeof(==),T<:SPIRV.Vec,T<:SPIRV.Vec})   # time: 0.090504006
    Base.precompile(Tuple{typeof(validate),IR})   # time: 0.08545839
    Base.precompile(Tuple{typeof(merge_vertices!),DeltaGraph{Int64},Int64,Int64,Int64})   # time: 0.08446557
    Base.precompile(Tuple{Type{Vec2},Int64,Int64})   # time: 0.0815935
    Base.precompile(Tuple{typeof(deserialize),Type{Arr{2, Int64}},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.07951385
    Base.precompile(Tuple{typeof(datasize),NativeLayout,Type{Vec{2, Int16}}})   # time: 0.07884036
    Base.precompile(Tuple{typeof(clamp),Float64,Float64,Float64})   # time: 0.07069411
    Base.precompile(Tuple{typeof(merge_blocks),FunctionDefinition})   # time: 0.0681418
    Base.precompile(Tuple{Type{Mat4},Vec4,Vec4,Vec4,Vec4})   # time: 0.068016395
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},String})   # time: 0.067255415
    Base.precompile(Tuple{typeof(==),AnnotatedFunction,AnnotatedFunction})   # time: 0.066538244
    Base.precompile(Tuple{typeof(all),typeof(iszero),Vec{4, Float64}})   # time: 0.06613931
    Base.precompile(Tuple{Type{ShaderExecutionOptions},ExecutionModel})   # time: 0.06404015
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,FunctionControl,Type})   # time: 0.060250796
    Base.precompile(Tuple{typeof(deserialize),Type{Mat4},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.05959624
    Base.precompile(Tuple{typeof(datasize),ShaderLayout,StructType})   # time: 0.058935545
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},StorageClass})   # time: 0.0580453
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(/),Float64,Vec{2, UInt32}})   # time: 0.05775136
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ExecutionMode,Type})   # time: 0.05598825
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Capability,Type})   # time: 0.05290829
    Base.precompile(Tuple{typeof(isapprox),PhysicalModule,PhysicalModule})   # time: 0.052294467
    Base.precompile(Tuple{typeof(validate),ComputeExecutionOptions,ExecutionModel})   # time: 0.049567237
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec{2, Int32},Vec2})   # time: 0.049452133
    Base.precompile(Tuple{typeof(show),IOContext{IOBuffer},ControlTree})   # time: 0.048165374
    Base.precompile(Tuple{typeof(deserialize),Type{Mat{2, 5, Float32}},Vector{UInt8},NativeLayout})   # time: 0.047704756
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec3,Float64})   # time: 0.047440596
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ExecutionModel,Type})   # time: 0.046129704
    Base.precompile(Tuple{typeof(axes),Mat})   # time: 0.045747574
    Base.precompile(Tuple{typeof(deserialize),Type{Vec{2, Int16}},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{UInt64}}, true},NativeLayout})   # time: 0.044925444
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Decoration,Type})   # time: 0.044660993
    Base.precompile(Tuple{typeof(deserialize),Type{Vec3},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{UInt64}}, true},NativeLayout})   # time: 0.04421092
    Base.precompile(Tuple{typeof(zero),Type{Arr{16, Float32}}})   # time: 0.043922152
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,FunctionControl,OperandInfo})   # time: 0.043839607
    Base.precompile(Tuple{typeof(deserialize),Type{Arr{2, Vec3}},Vector{UInt8},NoPadding})   # time: 0.042678997
    Base.precompile(Tuple{typeof(getproperty),Vec3,Symbol})   # time: 0.042268034
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, UInt32, Int64, Tuple{UInt32, Float32}, Float32, Int64, Int64, Int64}},Vector{UInt8},NativeLayout})   # time: 0.04197337
    Base.precompile(Tuple{typeof(serialize),Vector{Arr{2, UInt8}},NoPadding})   # time: 0.04172489
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,SelectionControl,Type})   # time: 0.04088524
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,StructType})   # time: 0.04082586
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,LoopControl,Type})   # time: 0.040808767
    Base.precompile(Tuple{typeof(all),typeof(isone),Arr{16, Vec4}})   # time: 0.040515576
    Base.precompile(Tuple{typeof(getproperty),Vec{2, Int16},Symbol})   # time: 0.040473275
    Base.precompile(Tuple{typeof(all),Vec{2, Bool}})   # time: 0.03982332
    Base.precompile(Tuple{Type{Constant},Tuple{Float64, Tuple{UInt32, Int64}},ModuleTarget,Translation})   # time: 0.039397467
    Base.precompile(Tuple{typeof(compact),DeltaGraph{Int64}})   # time: 0.039344277
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},SelectionControl})   # time: 0.03925636
    Base.precompile(Tuple{typeof(deserialize),Type{Vec{2, Int16}},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.03873732
    isdefined(SPIRV, Symbol("#92#93")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#92#93")),IOContext{IOBuffer},Vararg{Any}})   # time: 0.03858122
    Base.precompile(Tuple{Type{Translation}})   # time: 0.038460627
    Base.precompile(Tuple{typeof(add_options!),EntryPoint,CommonExecutionOptions})   # time: 0.037719883
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:storage_classes,), Tuple{Vector{StorageClass}}},Type{ShaderInterface},ExecutionModel})   # time: 0.037197288
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,Nothing,ResultID,Vararg{Any}})   # time: 0.036614817
    Base.precompile(Tuple{Type{DeltaGraph}})   # time: 0.036244377
    Base.precompile(Tuple{typeof(deserialize_mutable),Type{Vec4},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{UInt64}}, true},NativeLayout})   # time: 0.035864916
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, UInt32, Int64, Tuple{UInt32, Float32}, Float32, Int64, Int64, Int64}},Vector{UInt8},NoPadding})   # time: 0.035554446
    Base.precompile(Tuple{typeof(parse),Type{SPIRType},Instruction,BijectiveMapping{ResultID, SPIRType},BijectiveMapping{ResultID, Constant}})   # time: 0.035529926
    Base.precompile(Tuple{typeof(rem_vertex!),DeltaGraph{Int64},Int64})   # time: 0.035337735
    Base.precompile(Tuple{Type{Vec3},Int64,Int64,Int64})   # time: 0.034599207
    Base.precompile(Tuple{typeof(one),Type{Arr{16, Vec4}}})   # time: 0.034581836
    Base.precompile(Tuple{Type{EdgeClassification},DeltaGraph{Int64}})   # time: 0.033855524
    Base.precompile(Tuple{typeof(decorate!),Decorations,Decoration,Int64})   # time: 0.033692278
    Base.precompile(Tuple{typeof(one),Type{Arr{16, Float32}}})   # time: 0.03344138
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,StorageClass,Type})   # time: 0.033103656
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,BuiltIn,Type})   # time: 0.032736514
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, UInt32, Int64, Tuple{UInt32, Float32}, Float32, Int64, Int64, Int64},NoPadding})   # time: 0.032647748
    Base.precompile(Tuple{typeof(zero),Type{Arr{16, Vec4}}})   # time: 0.03234131
    Base.precompile(Tuple{Type{Expression},OpCode,FloatType,ResultID,Core.SSAValue,Vararg{Any}})   # time: 0.03160907
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,FunctionType})   # time: 0.031479634
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, UInt32},VulkanLayout})   # time: 0.03141539
    Base.precompile(Tuple{Type{Vec2},Int64,Vararg{Int64}})   # time: 0.031375762
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SourceLanguage,Vararg{Any}})   # time: 0.031331662
    Base.precompile(Tuple{typeof(deserialize_immutable),Type{Tuple{Int64, UInt32}},Vector{UInt8},NoPadding})   # time: 0.031040536
    Base.precompile(Tuple{Type{TypeMap}})   # time: 0.030466374
    let fbody = try Base.bodyfunction(which(spir_type, (DataType,TypeMap,))) catch missing end
    if !ismissing(fbody)
        precompile(fbody, (Bool,Nothing,Bool,typeof(spir_type),DataType,TypeMap,))
    end
end   # time: 0.030451998
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,MemoryModel,Type})   # time: 0.030207478
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,SourceLanguage,Type})   # time: 0.029894222
    Base.precompile(Tuple{typeof(exp),Float32})   # time: 0.029820817
    Base.precompile(Tuple{typeof(add_type_layouts!),TypeMetadata,VulkanLayout})   # time: 0.029666195
    Base.precompile(Tuple{typeof(edges),DeltaGraph{Int64}})   # time: 0.029454432
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Dim,Type})   # time: 0.029300664
    Base.precompile(Tuple{typeof(prod),Vec3})   # time: 0.029252056
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,AddressingModel,Type})   # time: 0.028935952
    Base.precompile(Tuple{typeof(getindex),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Int64,Int64})   # time: 0.028798912
    Base.precompile(Tuple{typeof(deserialize),Type{Mat{2, 5, Float32}},Vector{UInt8},NoPadding})   # time: 0.02871674
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,ResultID,FunctionControl,Vararg{Any}})   # time: 0.028310657
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ImageFormat,Type})   # time: 0.027950462
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,ResultID,StorageClass,Vararg{Any}})   # time: 0.02792068
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},MemoryAccess})   # time: 0.027661145
    Base.precompile(Tuple{typeof(deserialize),Type{Mat{2, 3, Float32}},Vector{UInt8},NoPadding})   # time: 0.027129129
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Arr{2, UInt8}}},Vector{UInt8},NativeLayout})   # time: 0.02637409
    Base.precompile(Tuple{typeof(mod),Float64,Float64})   # time: 0.026371159
    Base.precompile(Tuple{typeof(flow_through),Function,ControlFlowGraph{Graphs.SimpleGraphs.SimpleEdge{Int64}, Int64, DeltaGraph{Int64}},Int64})   # time: 0.02611375
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},BuiltIn})   # time: 0.0259442
    Base.precompile(Tuple{typeof(getindex),Pointer{Vector{Int64}},Int64})   # time: 0.025845675
    Base.precompile(Tuple{typeof(sum),Vec{4, Float64}})   # time: 0.025838543
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,UInt32,Literal})   # time: 0.02581121
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.025652839
    Base.precompile(Tuple{typeof(add_merge_headers!),IR})   # time: 0.025553757
    Base.precompile(Tuple{typeof(deserialize),Type{Mat{2, 3, Float32}},Vector{UInt8},NativeLayout})   # time: 0.025178501
    Base.precompile(Tuple{typeof(serialize),Mat{2, 3, Float32},VulkanLayout})   # time: 0.025084358
    Base.precompile(Tuple{typeof(parse),Type{Module},String})   # time: 0.024966445
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Arr{2, Int64}}},Vector{UInt8},NoPadding})   # time: 0.024635779
    Base.precompile(Tuple{typeof(format_parameter),OperandInfo})   # time: 0.02461974
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Arr{2, Int64}}},Vector{UInt8},NativeLayout})   # time: 0.02449341
    Base.precompile(Tuple{typeof(sinks),DeltaGraph{Int64}})   # time: 0.024385056
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:memory_model,), Tuple{MemoryModel}},Type{IR}})   # time: 0.024298187
    Base.precompile(Tuple{typeof(deserialize),Type{Mat4},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{UInt64}}, true},NativeLayout})   # time: 0.024205957
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ResultID,Id})   # time: 0.02412827
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Arr{2, UInt8}}},Vector{UInt8},NoPadding})   # time: 0.024100946
    Base.precompile(Tuple{SampledImage{Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4}},Vec2})   # time: 0.024091452
    Base.precompile(Tuple{typeof(showerror),IOBuffer,CompilationError})   # time: 0.023281636
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, Variable}})   # time: 0.023202918
    Base.precompile(Tuple{typeof(getproperty),Vec{2, Float64},Symbol})   # time: 0.022924997
    Base.precompile(Tuple{typeof(postdominator),ControlFlowGraph{Graphs.SimpleGraphs.SimpleEdge{Int64}, Int64, DeltaGraph{Int64}},Int64})   # time: 0.022599678
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},FunctionControl})   # time: 0.022295572
    Base.precompile(Tuple{typeof(==),Vec2,Vec2})   # time: 0.022248147
    Base.precompile(Tuple{typeof(show),IOBuffer,MIME{Symbol("text/plain")},IR})   # time: 0.022191046
    Base.precompile(Tuple{typeof(nexs),FunctionDefinition})   # time: 0.022133015
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(/),Float32,Vec{2, UInt32}})   # time: 0.021908073
    isdefined(SPIRV, Symbol("#362#363")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#362#363")),Int64})   # time: 0.02185187
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(+),Vec2,Vec2})   # time: 0.021720702
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Decoration})   # time: 0.021662366
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Vec3}},Vector{UInt8},NativeLayout})   # time: 0.02159506
    Base.precompile(Tuple{typeof(serialize),Mat{2, 5, Float32},VulkanLayout})   # time: 0.021551535
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},MemoryModel})   # time: 0.021382717
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec3,Float32})   # time: 0.021376979
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, Vec3}},Vector{UInt8},NoPadding})   # time: 0.021062046
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, FunctionType}})   # time: 0.021013206
    Base.precompile(Tuple{typeof(serialize),Vector{Arr{2, UInt8}},VulkanLayout})   # time: 0.020982493
    Base.precompile(Tuple{typeof(add_options!),EntryPoint,ComputeExecutionOptions})   # time: 0.020925678
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{UInt32, Float32}},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.020707231
    Base.precompile(Tuple{typeof(deserialize),Type{Vec3},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.020648416
    Base.precompile(Tuple{typeof(emit_expression!),ModuleTarget,Translation,SPIRVTarget,FunctionDefinition,Expr,Type,Block})   # time: 0.020163596
    Base.precompile(Tuple{typeof(emit_constant!),ModuleTarget,Translation,Vec2})   # time: 0.01998175
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ExecutionModel})   # time: 0.019724036
    Base.precompile(Tuple{typeof(datasize),NoPadding,Type{Vec{2, Int16}}})   # time: 0.019493775
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},SourceLanguage})   # time: 0.019138418
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Arr{2, UInt8}}},Vector{UInt8},VulkanLayout})   # time: 0.018657226
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Arr{2, Int64}}},Vector{UInt8},VulkanLayout})   # time: 0.018651685
    Base.precompile(Tuple{typeof(acos),Float32})   # time: 0.01852641
    Base.precompile(Tuple{typeof(copy),Pointer{Vec{2, Int64}}})   # time: 0.018411348
    Base.precompile(Tuple{typeof(convert),Type{Vec{2, Int16}},Vec{2, Int64}})   # time: 0.018315293
    Base.precompile(Tuple{typeof(convert),Type{Arr{3, Float64}},Arr{3, Float32}})   # time: 0.018296905
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, UInt32}},Vector{UInt8},NativeLayout})   # time: 0.01817249
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, Vec3},NativeLayout})   # time: 0.017960545
    Base.precompile(Tuple{typeof(deserialize),Type{Float32},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.017815348
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},AddressingModel})   # time: 0.017786527
    Base.precompile(Tuple{typeof(serialize),Arr{2, Vec3},NoPadding})   # time: 0.017766068
    Base.precompile(Tuple{typeof(serialize),Vector{Arr{2, Int64}},NoPadding})   # time: 0.017692944
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,ResultID,ResultID,Vararg{ResultID}})   # time: 0.017650267
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(mod),Vec2,Float32})   # time: 0.017596858
    Base.precompile(Tuple{typeof(deserialize),Type{Int32},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.017418448
    Base.precompile(Tuple{Type{ShaderInterface},ExecutionModel})   # time: 0.01731018
    Base.precompile(Tuple{typeof(serialize),Mat{2, 5, Float32},NoPadding})   # time: 0.017197013
    Base.precompile(Tuple{typeof(append_debug_annotations!),Vector{Instruction},ResultID,Metadata})   # time: 0.016965944
    isdefined(SPIRV, Symbol("#362#363")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#362#363")),Int64})   # time: 0.016951239
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ImageOperands,OperandInfo})   # time: 0.01659929
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ExecutionMode})   # time: 0.016552286
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,ResultID,Float32})   # time: 0.016404139
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, UInt32},NoPadding})   # time: 0.016349938
    Base.precompile(Tuple{typeof(fill_phi_branches!),IR})   # time: 0.01620581
    Base.precompile(Tuple{typeof(size),Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4},Int64})   # time: 0.016197478
    Base.precompile(Tuple{typeof(nesting_levels),ControlTree})   # time: 0.015999429
    Base.precompile(Tuple{Type{SPIRVInterpreter}})   # time: 0.01589988
    Base.precompile(Tuple{Type{Arr{Float32}},Float64,Float64,Float64,Float64,Float64})   # time: 0.01582676
    Base.precompile(Tuple{typeof(copyto!),Vec3,Vec{3, Float64}})   # time: 0.015712174
    Base.precompile(Tuple{Type{Mat{2, 3, Float32}},Vec2,Vec2,Vec2})   # time: 0.01529733
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:interp,), Tuple{SPIRVInterpreter}},typeof(compile),Any,Any,SupportedFeatures})   # time: 0.01510083
    Base.precompile(Tuple{typeof(dataoffset),NoPadding,DataType,Int64})   # time: 0.015017008
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},OpCodeGLSL})   # time: 0.015014648
    Base.precompile(Tuple{Type{Instruction},OpCode,ResultID,ResultID,Int32})   # time: 0.014837691
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},LoopControl})   # time: 0.014584789
    Base.precompile(Tuple{typeof(datasize),NoPadding,Type{Mat4}})   # time: 0.014485354
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Capability})   # time: 0.014409048
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,SelectionControl,OperandInfo})   # time: 0.014379671
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,LoopControl,OperandInfo})   # time: 0.014353042
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, FloatType}})   # time: 0.014075749
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ImageFormat})   # time: 0.014059157
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Dim})   # time: 0.014046105
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,ResultID,Int64,Vararg{Int64}})   # time: 0.014024696
    Base.precompile(Tuple{Type{StructType},Vector{FloatType}})   # time: 0.013851804
    Base.precompile(Tuple{typeof(deserialize),Type{Arr{2, Vec3}},Vector{UInt8},VulkanLayout})   # time: 0.013753846
    Base.precompile(Tuple{typeof(serialize),Vector{Arr{2, Int64}},NativeLayout})   # time: 0.013730952
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Int64}},Vector{UInt8},NativeLayout})   # time: 0.013648545
    Base.precompile(Tuple{typeof(datasize),NoPadding,Type{Vec4}})   # time: 0.013089554
    Base.precompile(Tuple{typeof(getindex),VulkanLayout,Type{Mat{2, 5, Float32}}})   # time: 0.012963774
    Base.precompile(Tuple{typeof(similar),Arr{4, Float64}})   # time: 0.012939882
    Base.precompile(Tuple{typeof(similar),Mat{2, 2, Float64}})   # time: 0.012852165
    Base.precompile(Tuple{Type{Constant},Int64})   # time: 0.012667909
    Base.precompile(Tuple{typeof(==),PhysicalModule,PhysicalModule})   # time: 0.012638215
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec2,Vec{2, Int64}})   # time: 0.012636303
    Base.precompile(Tuple{typeof(decorate!),Decorations,Decoration,Int64,Int64,Vararg{Int64}})   # time: 0.012474768
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, VectorType}})   # time: 0.01246929
    isdefined(SPIRV, Symbol("#347#350")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#347#350")),Vector{Int64}})   # time: 0.012445634
    Base.precompile(Tuple{typeof(validate),FragmentExecutionOptions,ExecutionModel})   # time: 0.012347764
    Base.precompile(Tuple{typeof(deserialize),Type{Arr{2, UInt8}},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.012299045
    Base.precompile(Tuple{typeof(deserialize_mutable),Type{Vec4},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.012271895
    Base.precompile(Tuple{typeof(log),Float32})   # time: 0.012168827
    Base.precompile(Tuple{typeof(getproperty),Vec{4, Float64},Symbol})   # time: 0.012140259
    Base.precompile(Tuple{Type{LayoutInfo},Int64,Int64,Int64,Vector{UInt64}})   # time: 0.012132751
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, ImageType}})   # time: 0.011852406
    Base.precompile(Tuple{typeof(serialize),Mat{2, 3, Float32},NoPadding})   # time: 0.011847815
    Base.precompile(Tuple{typeof(serialize),Vector{Vec3},VulkanLayout})   # time: 0.011712737
    isdefined(SPIRV, Symbol("#347#350")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#347#350")),Vector{Float64}})   # time: 0.011689831
    Base.precompile(Tuple{Type{StructType},Vector{ArrayType}})   # time: 0.011642534
    Base.precompile(Tuple{typeof(validate),CommonExecutionOptions,ExecutionModel})   # time: 0.011508698
    Base.precompile(Tuple{typeof(deserialize),Type{Int8},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{UInt64}}, true},NativeLayout})   # time: 0.011505154
    Base.precompile(Tuple{typeof(*),Int64,Vec2})   # time: 0.011476992
    Base.precompile(Tuple{typeof(decorate!),Decorations,Decoration,Int64,Int64,Int64})   # time: 0.011463244
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,Type})   # time: 0.011312496
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.011280417
    Base.precompile(Tuple{typeof(invalidate_all!),SPIRVInterpreter})   # time: 0.011249667
    Base.precompile(Tuple{Type{FunctionType},VoidType,Vector{PointerType}})   # time: 0.01123974
    Base.precompile(Tuple{Type{StructType},Vector{ScalarType}})   # time: 0.011150739
    Base.precompile(Tuple{Type{StructType},Vector{StructType}})   # time: 0.011125215
    Base.precompile(Tuple{typeof(serialize),Base.RefValue{Vec4},NativeLayout})   # time: 0.011110139
    Base.precompile(Tuple{typeof(serialize),Base.RefValue{Vec4},VulkanLayout})   # time: 0.011087055
    Base.precompile(Tuple{typeof(similar),Arr{2, Vec2}})   # time: 0.011055506
    Base.precompile(Tuple{typeof(decorate!),Metadata,Int64,Decoration,Int64})   # time: 0.011028494
    Base.precompile(Tuple{typeof(serialize),Vector{Arr{2, Int64}},VulkanLayout})   # time: 0.010981906
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, PointerType}})   # time: 0.010932821
    Base.precompile(Tuple{typeof(add_options!),EntryPoint,TessellationExecutionOptions})   # time: 0.010828068
    Base.precompile(Tuple{typeof(getproperty),Vec4,Symbol})   # time: 0.010823759
    Base.precompile(Tuple{typeof(serialize),Base.RefValue{Vec4},NoPadding})   # time: 0.010771547
    Base.precompile(Tuple{typeof(deserialize_immutable),Type{Tuple{Vec3, Vec3}},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.010759177
    Base.precompile(Tuple{typeof(merge!),VulkanLayout,VulkanLayout})   # time: 0.010734187
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(exp),Vec2})   # time: 0.010733794
    Base.precompile(Tuple{typeof(serialize!),Vector{UInt8},Tuple{UInt32, Float32},VulkanLayout})   # time: 0.010697769
    Base.precompile(Tuple{typeof(add_options!),EntryPoint,FragmentExecutionOptions})   # time: 0.010687074
    Base.precompile(Tuple{typeof(serialize),Mat{2, 3, Float32},NativeLayout})   # time: 0.010676302
    Base.precompile(Tuple{typeof(common_ancestor),DominatorTree,Vector{DominatorTree}})   # time: 0.010648712
    Base.precompile(Tuple{typeof(serialize),Arr{2, Vec3},VulkanLayout})   # time: 0.010537911
    Base.precompile(Tuple{typeof(serialize!),Vector{UInt8},Mat4,VulkanLayout})   # time: 0.010429058
    Base.precompile(Tuple{typeof(validate),MeshExecutionOptions,ExecutionModel})   # time: 0.010376064
    Base.precompile(Tuple{Type{FunctionType},FloatType,Vector{BooleanType}})   # time: 0.010316967
    Base.precompile(Tuple{Type{StructType},Vector{IntegerType}})   # time: 0.010304434
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, StructType}})   # time: 0.010218435
    Base.precompile(Tuple{typeof(eachindex),Arr{2, Int64}})   # time: 0.010132211
    Base.precompile(Tuple{typeof(deserialize),Type{Matrix{Int64}},Vector{UInt8},VulkanLayout,Tuple{Int64, Int64}})   # time: 0.010090401
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, ArrayType}})   # time: 0.009900763
    Base.precompile(Tuple{typeof(datasize),NoPadding,Type{Mat{2, 3, Float32}}})   # time: 0.009896059
    Base.precompile(Tuple{typeof(concrete_datasize),NoPadding,Mat{2, 3, Float32}})   # time: 0.009868277
    Base.precompile(Tuple{Type{Mat{3, 4, Float32}},Vec3,Vararg{Vec3}})   # time: 0.009852596
    Base.precompile(Tuple{typeof(serialize),Arr{2, Vec3},NativeLayout})   # time: 0.009844374
    let fbody = try Base.bodyfunction(which(spir_type, (DataType,TypeMap,))) catch missing end
    if !ismissing(fbody)
        precompile(fbody, (Bool,StorageClass,Bool,typeof(spir_type),DataType,TypeMap,))
    end
end   # time: 0.00982191
    Base.precompile(Tuple{typeof(validate),GeometryExecutionOptions,ExecutionModel})   # time: 0.009521256
    Base.precompile(Tuple{typeof(CompositeConstruct),Type{Mat{3, 4, Float32}},Vec3,Vec3,Vec3,Vec3})   # time: 0.009252763
    Base.precompile(Tuple{Type{Mat{2, 2, Float64}},Vec{2, Float64},Vararg{Vec{2, Float64}}})   # time: 0.009174421
    Base.precompile(Tuple{typeof(concrete_datasize),NoPadding,Base.RefValue{Vec4}})   # time: 0.009081267
    Base.precompile(Tuple{typeof(isapprox),StructType,StructType})   # time: 0.009046574
    Base.precompile(Tuple{typeof(validate),TessellationExecutionOptions,ExecutionModel})   # time: 0.009018506
    Base.precompile(Tuple{typeof(dominators),DeltaGraph{Int64}})   # time: 0.008949599
    Base.precompile(Tuple{typeof(datasize),NoPadding,Type{Base.RefValue{Vec4}}})   # time: 0.008947683
    Base.precompile(Tuple{typeof(==),FeatureRequirements,FeatureRequirements})   # time: 0.008878624
    Base.precompile(Tuple{typeof(get_signature),Expr})   # time: 0.008794902
    Base.precompile(Tuple{typeof(datasize),NoPadding,Type})   # time: 0.008772115
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Vec3}},Vector{UInt8},VulkanLayout})   # time: 0.008715957
    Base.precompile(Tuple{typeof(emit_expression!),ModuleTarget,Translation,SPIRVTarget,FunctionDefinition,Core.PhiNode,Type,Block})   # time: 0.008688691
    Base.precompile(Tuple{Type{StructType},Vector{MatrixType}})   # time: 0.008613914
    Base.precompile(Tuple{Type{Vec3},Float64,Vararg{Float64}})   # time: 0.008607035
    Base.precompile(Tuple{Type{TypeMetadata},VulkanLayout})   # time: 0.008483346
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.008360356
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,UInt32,Decoration})   # time: 0.008351044
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,Decoration,UInt32})   # time: 0.008290259
    Base.precompile(Tuple{typeof(deserialize),Type{Matrix{Int64}},Vector{UInt8},NativeLayout,Tuple{Int64, Int64}})   # time: 0.008244073
    Base.precompile(Tuple{Type{SPIRVInterpreter},Vector{Core.MethodTable}})   # time: 0.008184565
    isdefined(SPIRV, Symbol("#409#412")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#409#412")),Int64})   # time: 0.0081594
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,UInt32,Decoration,UInt32})   # time: 0.008143818
    Base.precompile(Tuple{Type{Vec{2, UInt32}},Int64,Vararg{Int64}})   # time: 0.00801599
    Base.precompile(Tuple{typeof(emit_constant!),ModuleTarget,Translation,Bool})   # time: 0.007961535
    Base.precompile(Tuple{Type{Expression},OpCode,FloatType,ResultID,Base.ReinterpretArray{UInt32, 1, Float64, Vector{Float64}, false}})   # time: 0.007943286
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007880885
    Base.precompile(Tuple{typeof(storage_class),Core.SSAValue,ModuleTarget,Translation,FunctionDefinition})   # time: 0.007767656
    Base.precompile(Tuple{typeof(deserialize),Type{UInt32},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.007720848
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007603416
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007589358
    Base.precompile(Tuple{typeof(==),ControlTree,ControlTree})   # time: 0.007585182
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,ResultID,Decoration})   # time: 0.007546198
    Base.precompile(Tuple{Type{StackFrame},AnnotatedModule,ResultID})   # time: 0.007540996
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007535147
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.00747193
    Base.precompile(Tuple{typeof(deserialize),Type{Int8},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.007305866
    Base.precompile(Tuple{typeof(datasize),VulkanLayout,Type{Int32}})   # time: 0.007298835
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Vec3}},Vector{UInt8},NoPadding})   # time: 0.007286612
    Base.precompile(Tuple{Type{DeltaGraph},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007285748
    Base.precompile(Tuple{Type{Expression},OpCode,FloatType,ResultID,Base.ReinterpretArray{UInt32, 1, Float32, Vector{Float32}, false}})   # time: 0.007204979
    Base.precompile(Tuple{Type{Expression},OpCode,IntegerType,ResultID,Base.ReinterpretArray{UInt32, 1, Int32, Vector{Int32}, false}})   # time: 0.007155532
    Base.precompile(Tuple{typeof(serialize),Mat{2, 5, Float32},NativeLayout})   # time: 0.007078615
    Base.precompile(Tuple{typeof(define_entry_point!),ModuleTarget,Translation,FunctionDefinition,ExecutionModel,CommonExecutionOptions})   # time: 0.006959847
    isdefined(SPIRV, Symbol("#381#382")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#381#382")),Int64})   # time: 0.006829103
    Base.precompile(Tuple{typeof(deserialize),Type{Arr{2, Vec3}},Vector{UInt8},NativeLayout})   # time: 0.006798068
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:storage_classes, :interfaces), Tuple{Dict{DataType, Vector{StorageClass}}, Vector{DataType}}},Type{VulkanLayout},Vector{DataType}})   # time: 0.006542449
    Base.precompile(Tuple{typeof(define_entry_point!),ModuleTarget,Translation,FunctionDefinition,ExecutionModel,FragmentExecutionOptions})   # time: 0.006506816
    Base.precompile(Tuple{Type{Mat{2, 5, Float32}},Vec2,Vec2,Vec2,Vec2,Vec2})   # time: 0.006474031
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:interfaces,), Tuple{Vector{DataType}}},Type{VulkanLayout},Vector{DataType}})   # time: 0.006403541
    Base.precompile(Tuple{typeof(getindex),Pointer{Vector{Int32}},Int64})   # time: 0.006373497
    Base.precompile(Tuple{typeof(deserialize),Type{Base.RefValue{Vec4}},Vector{UInt8},VulkanLayout})   # time: 0.006174443
    Base.precompile(Tuple{typeof(define_entry_point!),ModuleTarget,Translation,FunctionDefinition,ExecutionModel,ComputeExecutionOptions})   # time: 0.006129186
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, IntegerType}})   # time: 0.006125278
    Base.precompile(Tuple{typeof(conflicted_merge_blocks),FunctionDefinition})   # time: 0.006112883
    isdefined(SPIRV, Symbol("#345#348")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#345#348")),Int64})   # time: 0.00609166
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Int64}},Vector{UInt8},VulkanLayout})   # time: 0.006005666
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Vararg{Pair{Int64, Int64}}})   # time: 0.005996202
    Base.precompile(Tuple{typeof(getindex),Mat{2, 2, Float64},Int64,Int64})   # time: 0.005945837
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, Vec3},NoPadding})   # time: 0.005926393
    Base.precompile(Tuple{typeof(getindex),Mat{4, 4, Float64},Int64,Int64})   # time: 0.005911714
    Base.precompile(Tuple{typeof(==),DeltaGraph{Int64},DeltaGraph{Int64}})   # time: 0.005869306
    Base.precompile(Tuple{typeof(append_decorations!),Vector{Instruction},ResultID,Metadata})   # time: 0.00582223
    Base.precompile(Tuple{Type{Vec4},Int64,Int64,Int64,Int64})   # time: 0.005772888
    Base.precompile(Tuple{typeof(all),typeof(iszero),Arr{16, Vec4}})   # time: 0.005731818
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,ArrayType})   # time: 0.005701952
    Base.precompile(Tuple{Type{ControlFlowGraph},DeltaGraph{Int64}})   # time: 0.005691444
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},IntegerType,ResultID})   # time: 0.005643931
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,PointerType})   # time: 0.005522875
    isdefined(SPIRV, Symbol("#callback#317")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#callback#317")),MethodInstance,UInt32})   # time: 0.005522492
    Base.precompile(Tuple{typeof(==),Vec{2, Int64},Vec{2, Int64}})   # time: 0.005395497
    isdefined(SPIRV, Symbol("#362#363")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#362#363")),Int64})   # time: 0.005350698
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(+),Vec3,Vec{3, Float64}})   # time: 0.005325812
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),FloatType})   # time: 0.005323607
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,ArrayType})   # time: 0.005296352
    Base.precompile(Tuple{typeof(deserialize_immutable),Type{Tuple{Int64, Vec3}},Vector{UInt8},NoPadding})   # time: 0.005198211
    Base.precompile(Tuple{Type{ImageType},Instruction,FloatType})   # time: 0.005172332
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),PointerType})   # time: 0.005159599
    Base.precompile(Tuple{Type{ShaderInterface},Any,Any,Any,Any,Any,Any})   # time: 0.0051402
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Capability,OperandInfo})   # time: 0.00513361
    Base.precompile(Tuple{typeof(datasize),VulkanLayout,Type{Int8}})   # time: 0.00511381
    Base.precompile(Tuple{typeof(CompositeConstruct),Type{Mat{2, 2, Float64}},Vec{2, Float64},Vec{2, Float64}})   # time: 0.005057729
    isdefined(SPIRV, Symbol("#14#15")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#14#15")),Tuple{ArrayType, ArrayType}})   # time: 0.004979398
    Base.precompile(Tuple{typeof(deserialize_immutable),Type{Tuple{Int64, UInt32, Int64, Tuple{UInt32, Float32}, Float32, Int64, Int64, Int64}},Vector{UInt8},NoPadding})   # time: 0.004948345
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),BooleanType})   # time: 0.004940251
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),IntegerType})   # time: 0.004928743
    Base.precompile(Tuple{typeof(deserialize),Type{Vector{Int64}},Vector{UInt8},NoPadding})   # time: 0.004917667
    Base.precompile(Tuple{typeof(sum),Arr{10, Float32}})   # time: 0.004892849
    Base.precompile(Tuple{typeof(-),Vec2,Vec2})   # time: 0.004891451
    Base.precompile(Tuple{typeof(==),Vec{2, Float64},Vec{2, Float64}})   # time: 0.004864865
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),ImageType})   # time: 0.0048555
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec{2, UInt32},Float32})   # time: 0.004791746
    Base.precompile(Tuple{typeof(eachindex),Arr{5, Float32}})   # time: 0.004773215
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,OpCodeGLSL,OperandInfo})   # time: 0.004770409
    Base.precompile(Tuple{typeof(add_options!),EntryPoint,MeshExecutionOptions})   # time: 0.004737852
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),ArrayType})   # time: 0.004693497
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,VoidType})   # time: 0.004687778
    Base.precompile(Tuple{Type{Arr},Vec3,Vec3})   # time: 0.004660166
    Base.precompile(Tuple{typeof(axes),Mat{2, 2, Float64}})   # time: 0.004639297
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,UInt32,OperandInfo})   # time: 0.004633299
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),VectorType})   # time: 0.004527514
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),MatrixType})   # time: 0.004488032
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),SampledImageType})   # time: 0.00448802
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Int64,OperandInfo})   # time: 0.004429953
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,VectorType})   # time: 0.0043428
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Float64,OperandInfo})   # time: 0.00431886
    Base.precompile(Tuple{typeof(deserialize),Type{Matrix{Int64}},Vector{UInt8},NoPadding,Tuple{Int64, Int64}})   # time: 0.004301646
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,MatrixType})   # time: 0.004300275
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,BooleanType})   # time: 0.004283122
    Base.precompile(Tuple{typeof(deserialize),Type{Int64},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{UInt64}}, true},NativeLayout})   # time: 0.004273641
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,VoidType})   # time: 0.004244708
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,SampledImageType})   # time: 0.004240321
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,SamplerType})   # time: 0.004235706
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,BooleanType})   # time: 0.004233997
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, UInt32},NativeLayout})   # time: 0.004221974
    Base.precompile(Tuple{typeof(emit_constant!),ModuleTarget,Translation,Float32})   # time: 0.004179732
    isdefined(SPIRV, Symbol("#362#363")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#362#363")),Int64})   # time: 0.004179708
    Base.precompile(Tuple{Type{Vec{1, Float64}},Float64})   # time: 0.004149342
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,StructType})   # time: 0.004141263
    isdefined(SPIRV, Symbol("#376#378")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#376#378")),StructType})   # time: 0.004118159
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Int32,OperandInfo})   # time: 0.004105949
    Base.precompile(Tuple{typeof(-),Vec{3, Float64},Vec{3, Float64}})   # time: 0.004066403
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Core.SSAValue,OperandInfo})   # time: 0.004050053
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(-),Vec2,Vec2})   # time: 0.004049094
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{UInt32, Float32}},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.004006092
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Float32,OperandInfo})   # time: 0.004002192
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ExecutionMode,OperandInfo})   # time: 0.003989866
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,FloatType})   # time: 0.003964414
    Base.precompile(Tuple{typeof(validate),Shader})   # time: 0.003956772
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Decoration,OperandInfo})   # time: 0.003922008
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,ArrayType})   # time: 0.003920401
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},ResultID,ImageType})   # time: 0.003867521
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:storage_classes, :variable_decorations, :features), Tuple{Vector{StorageClass}, Dictionary{Int64, Decorations}, SupportedFeatures}},Type{ShaderInterface},ExecutionModel})   # time: 0.003830398
    Base.precompile(Tuple{typeof(datasize),NoPadding,Type{Tuple{Int64, Vec3}}})   # time: 0.003817015
    Base.precompile(Tuple{typeof(all),typeof(iszero),Arr{16, Float32}})   # time: 0.003814267
    Base.precompile(Tuple{typeof(sum),Vec4})   # time: 0.003803154
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, UInt32, Int64, Tuple{UInt32, Float32}, Float32, Int64, Int64, Int64},NativeLayout})   # time: 0.003802734
    Base.precompile(Tuple{typeof(axes),Arr{2, Int64}})   # time: 0.003801382
    Base.precompile(Tuple{typeof(setindex!),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Vec4,Int64})   # time: 0.003793432
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,StorageClass,OperandInfo})   # time: 0.003792709
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,VectorType})   # time: 0.003788764
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,MatrixType})   # time: 0.003767638
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(ceil),Vec2})   # time: 0.003757528
    Base.precompile(Tuple{typeof(serialize),Vector{Int64},VulkanLayout})   # time: 0.003753936
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},SampledImageType,ResultID})   # time: 0.003718081
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,IntegerType})   # time: 0.00371128
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,BuiltIn,OperandInfo})   # time: 0.003710085
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,SourceLanguage,OperandInfo})   # time: 0.003705484
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,Variable})   # time: 0.003697546
    Base.precompile(Tuple{typeof(emit_constant!),ModuleTarget,Translation,Int32})   # time: 0.003695472
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,MatrixType})   # time: 0.00369232
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, UInt32, Int64, Tuple{UInt32, Float32}, Float32, Int64, Int64, Int64},VulkanLayout})   # time: 0.003638561
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,FloatType})   # time: 0.003624454
    isdefined(SPIRV, Symbol("#95#96")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#95#96")),ArrayType})   # time: 0.003620223
    Base.precompile(Tuple{typeof(serialize),Tuple{Int64, Vec3},VulkanLayout})   # time: 0.00360619
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, Any},ResultID,ImageType})   # time: 0.003603936
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(+),Vec3,Vec3})   # time: 0.003592984
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,AddressingModel,OperandInfo})   # time: 0.003561791
    Base.precompile(Tuple{typeof(*),Vec{3, Float64},Vec{3, Float64}})   # time: 0.003554827
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,String,OperandInfo})   # time: 0.003546929
    Base.precompile(Tuple{typeof(serialize),Matrix{Int64},VulkanLayout})   # time: 0.003543435
    Base.precompile(Tuple{typeof(eachindex),Mat{2, 2, Float64}})   # time: 0.003536624
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ExecutionModel,OperandInfo})   # time: 0.003531236
    Base.precompile(Tuple{typeof(show),IOContext{IOBuffer},MIME{Symbol("text/plain")},IR})   # time: 0.003505026
    Base.precompile(Tuple{Type{StructType},Vector{VectorType}})   # time: 0.003485345
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ResultID,OperandInfo})   # time: 0.003464133
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Dim,OperandInfo})   # time: 0.003427033
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},SamplerType,ResultID})   # time: 0.003426176
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:storage_classes, :variable_decorations), Tuple{Vector{StorageClass}, Dictionary{Int64, Decorations}}},Type{ShaderInterface},ExecutionModel})   # time: 0.003404883
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,MemoryModel,OperandInfo})   # time: 0.003397667
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},StructType,ResultID})   # time: 0.00338591
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ImageFormat,OperandInfo})   # time: 0.003343784
    Base.precompile(Tuple{typeof(serialize),Vector{Int64},NativeLayout})   # time: 0.003324273
    Base.precompile(Tuple{typeof(store_expr),Expr})   # time: 0.003321821
    Base.precompile(Tuple{typeof(serialize),Matrix{Int64},NativeLayout})   # time: 0.003275221
    Base.precompile(Tuple{typeof(load_expr),Expr})   # time: 0.00325887
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{ResultID, SPIRType},FloatType,ResultID})   # time: 0.003242286
    Base.precompile(Tuple{Type{Vec2},Float64,Float64})   # time: 0.003198813
    Base.precompile(Tuple{typeof(cap_world),UInt64,UInt32})   # time: 0.003163836
    isdefined(SPIRV, Symbol("#409#412")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#409#412")),Int64})   # time: 0.003143672
    Base.precompile(Tuple{typeof(serialize!),Vector{UInt8},Tuple{Float32, Float32, Float32},NativeLayout})   # time: 0.00310549
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,VectorType})   # time: 0.003070028
    Base.precompile(Tuple{typeof(datasize),NativeLayout,Type{Mat4}})   # time: 0.003067814
    Base.precompile(Tuple{Type{Expression},Instruction,BijectiveMapping{ResultID, SPIRType}})   # time: 0.003040137
    Base.precompile(Tuple{typeof(/),Vec2,Float32})   # time: 0.00303434
    Base.precompile(Tuple{typeof(deserialize),Type{UInt32},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.003033664
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,IntegerType})   # time: 0.003027343
    Base.precompile(Tuple{typeof(load_variables!),Vector{ResultID},Block,ModuleTarget,Translation,FunctionDefinition,OpCode})   # time: 0.002989054
    Base.precompile(Tuple{typeof(serialize!),Vector{UInt8},Vec{2, Int16},NativeLayout})   # time: 0.002904299
    Base.precompile(Tuple{typeof(setindex!),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Vec4,Int64,Int64})   # time: 0.002799733
    Base.precompile(Tuple{typeof(deserialize),Type{Int64},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},NoPadding})   # time: 0.002797197
    Base.precompile(Tuple{typeof(has_decoration),Decorations,Decoration})   # time: 0.002791306
    Base.precompile(Tuple{typeof(deserialize),Type{Int32},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.002749256
    Base.precompile(Tuple{typeof(store_expr),Int64,Expr})   # time: 0.002718776
    Base.precompile(Tuple{typeof(deserialize),Type{Int64},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.00271358
    Base.precompile(Tuple{typeof(validate),FragmentExecutionOptions})   # time: 0.002615083
    Base.precompile(Tuple{typeof(getindex),Pointer{Vector{Vec2}},Int64})   # time: 0.002421156
    isdefined(SPIRV, Symbol("#433#444")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#433#444")),Expr})   # time: 0.002398279
    Base.precompile(Tuple{typeof(serialize),Vector{Vec3},NativeLayout})   # time: 0.002370624
    Base.precompile(Tuple{SampledImage{Image{ImageFormatR16f, Dim2D, 0, false, false, 1, Float32}},Vec2})   # time: 0.002313156
    Base.precompile(Tuple{typeof(getindex),Mat{3, 4, Float32},Int64,Int64})   # time: 0.00229013
    Base.precompile(Tuple{typeof(getindex),Vec2,UInt32})   # time: 0.002286362
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, UInt32}},Vector{UInt8},VulkanLayout})   # time: 0.002267335
    Base.precompile(Tuple{Type{ControlTree},Int64,RegionType,Tuple{ControlTree, ControlTree, ControlTree}})   # time: 0.002254663
    isdefined(SPIRV, Symbol("#381#382")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#381#382")),Int64})   # time: 0.002253688
    Base.precompile(Tuple{typeof(store_expr),Symbol,Expr})   # time: 0.002217012
    Base.precompile(Tuple{typeof(has_decoration),Metadata,Int64,Decoration})   # time: 0.002203961
    Base.precompile(Tuple{typeof(getindex),Arr{3, Float64},Int64})   # time: 0.002191897
    Base.precompile(Tuple{typeof(getindex),Vec{2, Int32},UInt32})   # time: 0.002182497
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},StructType})   # time: 0.002162751
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, UInt32, Int64, Tuple{UInt32, Float32}, Float32, Int64, Int64, Int64}},Vector{UInt8},VulkanLayout})   # time: 0.002142531
    Base.precompile(Tuple{typeof(deserialize),Type{Tuple{Int64, Vec3}},Vector{UInt8},VulkanLayout})   # time: 0.002126956
    Base.precompile(Tuple{typeof(deserialize),Type{Float32},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.002116164
    isdefined(SPIRV, Symbol("#95#96")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#95#96")),MatrixType})   # time: 0.00210835
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:limit,), Tuple{Int64}},typeof(Core.Compiler.findall),Type{<:Tuple{Any, Bool}},NOverlayMethodTable})   # time: 0.002096781
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},SamplerType})   # time: 0.002091309
    Base.precompile(Tuple{typeof(remap_args!),Vector{ResultID},ModuleTarget,Translation,OpCode})   # time: 0.002079746
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},IntegerType})   # time: 0.002077303
    Base.precompile(Tuple{typeof(store_expr),Expr,Expr})   # time: 0.002057931
    Base.precompile(Tuple{typeof(getindex),Arr{5, Float32},UInt32})   # time: 0.002033234
    Base.precompile(Tuple{typeof(getindex),Arr{1, Float32},UInt32})   # time: 0.002024597
    Base.precompile(Tuple{typeof(serialize!),Vector{UInt8},Mat4,NativeLayout})   # time: 0.001979624
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},FloatType})   # time: 0.001961354
    Base.precompile(Tuple{typeof(promote_to_interface_block),FloatType,StorageClass})   # time: 0.001953308
    Base.precompile(Tuple{typeof(merge),Metadata,Metadata})   # time: 0.001933875
    Base.precompile(Tuple{typeof(image_type),ImageFormat,Dim,Int64,Bool,Bool,Int64})   # time: 0.001919037
    Base.precompile(Tuple{typeof(getindex),Arr{2, UInt8},UInt32})   # time: 0.001899146
    Base.precompile(Tuple{typeof(all),typeof(isone),Arr{16, Float32}})   # time: 0.001893898
    Base.precompile(Tuple{typeof(getindex),Arr{2, Int64},UInt32})   # time: 0.001878015
    Base.precompile(Tuple{typeof(setindex!),Vec4,Vec4})   # time: 0.001837664
    Base.precompile(Tuple{typeof(getindex),BijectiveMapping{ResultID, Constant},ResultID})   # time: 0.001837389
    Base.precompile(Tuple{typeof(sprintc_mime),Function,IR})   # time: 0.001800889
    Base.precompile(Tuple{Type{VulkanLayout},VulkanAlignment,TypeMap,Dict{IntegerType, Set{StorageClass}},Set{StructType}})   # time: 0.001792544
    Base.precompile(Tuple{typeof(ConvertUToPtr),Type,UInt64})   # time: 0.001735334
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:storage_classes, :variable_decorations, :type_metadata), Tuple{Vector{StorageClass}, Dictionary{Int64, Decorations}, Dictionary{DataType, Metadata}}},Type{ShaderInterface},ExecutionModel})   # time: 0.001696862
    Base.precompile(Tuple{typeof(==),Module,Module})   # time: 0.001668809
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:storage_classes, :variable_decorations, :type_metadata, :features), Tuple{Vector{StorageClass}, Dictionary{Int64, Decorations}, Dictionary{DataType, Metadata}, SupportedFeatures}},Type{ShaderInterface},ExecutionModel})   # time: 0.001661704
    Base.precompile(Tuple{typeof(getindex),BijectiveMapping{ResultID, SPIRType},VoidType})   # time: 0.001604105
    Base.precompile(Tuple{typeof(setindex!),Mat{2, 2, Float64},Mat{2, 2, Float64}})   # time: 0.001559853
    Base.precompile(Tuple{typeof(promote_to_interface_block),VectorType,StorageClass})   # time: 0.001559846
    Base.precompile(Tuple{typeof(serialize),Matrix{Int64},NoPadding})   # time: 0.00154702
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, MatrixType}})   # time: 0.001545889
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},VectorType})   # time: 0.001525208
    Base.precompile(Tuple{typeof(serialize),Vector{Vec3},NoPadding})   # time: 0.001492873
    Base.precompile(Tuple{typeof(dataoffset),NativeLayout,Type{NTuple{4, NTuple{4, Float32}}},Int64})   # time: 0.001485904
    isdefined(SPIRV, Symbol("#119#120")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#119#120")),ResultID})   # time: 0.00145578
    isdefined(SPIRV, Symbol("#101#102")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#101#102")),Tuple{ResultID, SPIRType}})   # time: 0.001447893
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, VoidType}})   # time: 0.001433332
    Base.precompile(Tuple{typeof(setproperty!),Vec4,Symbol,UInt32})   # time: 0.001402347
    Base.precompile(Tuple{typeof(datasize),VulkanLayout,StructType})   # time: 0.001402097
    Base.precompile(Tuple{typeof(serialize),Vector{Int64},NoPadding})   # time: 0.001400594
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},BooleanType})   # time: 0.001397924
    Base.precompile(Tuple{typeof(source_version),SourceLanguage,UInt32})   # time: 0.001393656
    Base.precompile(Tuple{Type{SimpleTree},ControlNode,ControlTree,Vector{ControlTree}})   # time: 0.00137952
    Base.precompile(Tuple{typeof(load_if_variable!),Block,ModuleTarget,Translation,FunctionDefinition,Core.SSAValue})   # time: 0.001376425
    Base.precompile(Tuple{typeof(deserialize),Type{Int8},SubArray{UInt8, 1, Vector{UInt8}, Tuple{UnitRange{Int64}}, true},VulkanLayout})   # time: 0.001370062
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, SampledImageType}})   # time: 0.001348746
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{ResultID, SPIRType},ImageType})   # time: 0.001344933
    Base.precompile(Tuple{Type{Pointer},Base.RefValue{Vec{2, Int64}}})   # time: 0.001343153
    Base.precompile(Tuple{typeof(serialize!),Vector{UInt8},NTuple{4, Float32},NativeLayout})   # time: 0.001337568
    Base.precompile(Tuple{typeof(Core.kwcall),NamedTuple{(:origin,), Tuple{Symbol}},Type{FragmentExecutionOptions}})   # time: 0.001334887
    Base.precompile(Tuple{typeof(getindex),Arr{2, Vec2},UInt32})   # time: 0.001314134
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},UInt32})   # time: 0.001255223
    Base.precompile(Tuple{Type{Pointer},Base.RefValue{Tuple{Int64, Vec2}}})   # time: 0.001253771
    Base.precompile(Tuple{typeof(load_if_variable!),Block,ModuleTarget,Translation,FunctionDefinition,Core.Argument})   # time: 0.001250353
    Base.precompile(Tuple{typeof(dataoffset),NativeLayout,Type{Vec{2, Int16}},Int64})   # time: 0.001249078
    Base.precompile(Tuple{Type{Expression},OpCode,IntegerType,ResultID,Vector{Any}})   # time: 0.001230777
    Base.precompile(Tuple{typeof(dataoffset),NativeLayout,Type{Tuple{Int16, Int16}},Int64})   # time: 0.001202483
    Base.precompile(Tuple{typeof(setindex!),TypeMap,BooleanType,DataType})   # time: 0.00118397
    Base.precompile(Tuple{Type{ImageType},FloatType,Dim,UInt32,UInt32,UInt32,Bool,ImageFormat,Nothing})   # time: 0.001179843
    Base.precompile(Tuple{typeof(dataoffset),NativeLayout,Type{NTuple{4, Float32}},Int64})   # time: 0.001178857
    Base.precompile(Tuple{typeof(dataoffset),NativeLayout,Type{Mat4},Int64})   # time: 0.001178644
    Base.precompile(Tuple{Type{Decorations}})   # time: 0.001169558
    Base.precompile(Tuple{typeof(copy),Pointer{Vec2}})   # time: 0.001164415
    Base.precompile(Tuple{typeof(storage_class),Core.Argument,ModuleTarget,Translation,FunctionDefinition})   # time: 0.001160019
    Base.precompile(Tuple{Type{Expression},OpCode,ArrayType,ResultID,ResultID,Vararg{ResultID}})   # time: 0.001156747
    Base.precompile(Tuple{typeof(decorations),TypeMetadata,ArrayType})   # time: 0.001155419
    Base.precompile(Tuple{typeof(serialize!),Vector{UInt8},Vec{2, Int16},NoPadding})   # time: 0.001153042
    Base.precompile(Tuple{typeof(setproperty!),Vec4,Symbol,Float32})   # time: 0.001152592
    Base.precompile(Tuple{typeof(serialize!),Vector{UInt8},Tuple{Float32, Float32, Float32},NoPadding})   # time: 0.001142443
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(+),Vec2,Float32})   # time: 0.001140365
    Base.precompile(Tuple{Type{Vec3},Int64,Vararg{Int64}})   # time: 0.001108357
    Base.precompile(Tuple{Type{Expression},OpCode,FloatType,ResultID,ResultID,Vararg{Any}})   # time: 0.00110435
    Base.precompile(Tuple{typeof(setindex!),Vec{4, Float64},Vec{4, Float64}})   # time: 0.001081867
    isdefined(SPIRV, Symbol("#103#104")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#103#104")),Pair{ResultID, BooleanType}})   # time: 0.001077438
    Base.precompile(Tuple{typeof(Base.Broadcast.materialize!),Vec3,Broadcasted{BroadcastStyleSPIRV{Vec3}, Tuple{Base.OneTo{Int64}}, typeof(identity), Tuple{Vec3}}})   # time: 0.001050086
    Base.precompile(Tuple{typeof(all),typeof(iszero),Vec2})   # time: 0.001046947
    Base.precompile(Tuple{typeof(similar),Vec2})   # time: 0.001045527
    Base.precompile(Tuple{Type{Vec},Float32,Float32,Float32,Float32})   # time: 0.001043747
    Base.precompile(Tuple{typeof(clamp),Float32,Float32,Float32})   # time: 0.001016669
    isdefined(SPIRV, Symbol("#381#382")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#381#382")),Int64})   # time: 0.001013961
    Base.precompile(Tuple{SampledImage{Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4}},Float32,Float32})   # time: 0.00100878
    Base.precompile(Tuple{typeof(getindex),AnnotatedModule,ResultID})   # time: 0.001002083
