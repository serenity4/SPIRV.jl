    Base.precompile(Tuple{Core.kwftype(typeof(compile)),NamedTuple{(:interp,), Tuple{SPIRVInterpreter}},typeof(compile),Any,Any,AllSupported})   # time: 1.7579604
    Base.precompile(Tuple{typeof(+),Vec{3, Float64},Vec{3, Float64}})   # time: 1.0023506
    Base.precompile(Tuple{typeof(getproperty),Vec2,Symbol})   # time: 0.8407912
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:inferred, :interp), Tuple{Bool, SPIRVInterpreter}},Type{SPIRVTarget},Any,Type})   # time: 0.835573
    Base.precompile(Tuple{typeof(satisfy_requirements!),IR,AllSupported})   # time: 0.49765372
    Base.precompile(Tuple{typeof(annotate),Module})   # time: 0.3921493
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:satisfy_requirements,), Tuple{Bool}},Type{IR},Module})   # time: 0.3810238
    Base.precompile(Tuple{typeof(generate_ir),Expr})   # time: 0.33794513
    Base.precompile(Tuple{typeof(interpret),Function,Vararg{Any}})   # time: 0.3334405
    Base.precompile(Tuple{typeof(renumber_ssa),Module})   # time: 0.24484563
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec3,Vec3})   # time: 0.22290364
    Base.precompile(Tuple{typeof(merge),Decorations,Decorations})   # time: 0.20931436
    Base.precompile(Tuple{typeof(append_decorations!),Vector{Instruction},SSAValue,Decorations})   # time: 0.17971401
    Base.precompile(Tuple{Type{UseDefChain},AnnotatedModule,AnnotatedFunction,SSAValue,StackTrace})   # time: 0.17810965
    Base.precompile(Tuple{typeof(show),IOBuffer,MIME{Symbol("text/plain")},Module})   # time: 0.17229521
    Base.precompile(Tuple{typeof(dependent_functions),IR,SSAValue})   # time: 0.16881882
    Base.precompile(Tuple{typeof(read),IOBuffer,Type{PhysicalModule}})   # time: 0.15150395
    Base.precompile(Tuple{typeof(read),Type{Module},String})   # time: 0.1393475
    Base.precompile(Tuple{typeof(merge_vertices!),DeltaGraph{Int64},Int64,Int64,Int64})   # time: 0.12701377
    Base.precompile(Tuple{Type{Shader},SPIRVTarget,ShaderInterface})   # time: 0.11395769
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, Constant}})   # time: 0.112636864
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:memory_model,), Tuple{MemoryModel}},Type{IR}})   # time: 0.11169224
    Base.precompile(Tuple{typeof(validate),Module})   # time: 0.10740027
    Base.precompile(Tuple{typeof(emit_inst!),IR,IRMapping,SPIRVTarget,FunctionDefinition,Core.PhiNode,Type,Block})   # time: 0.101307794
    Base.precompile(Tuple{typeof(extract_bytes),Vec{2, Int16}})   # time: 0.098053224
    Base.precompile(Tuple{Type{TypeInfo},Vector{DataType},VulkanLayout})   # time: 0.09564046
    isdefined(SPIRV, Symbol("#266#267")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#266#267")),Int64})   # time: 0.08937321
    Base.precompile(Tuple{typeof(reinterpret_spirv),Type,Vector{UInt8}})   # time: 0.080912404
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,BuiltIn,Type})   # time: 0.080464825
    Base.precompile(Tuple{typeof(edges),DeltaGraph{Int64}})   # time: 0.07768306
    Base.precompile(Tuple{Type{Module},String})   # time: 0.077092476
    Base.precompile(Tuple{typeof(align),Vector{UInt8},DataType,IR})   # time: 0.07699176
    Base.precompile(Tuple{typeof(format_parameter),OperandInfo})   # time: 0.073730946
    Base.precompile(Tuple{typeof(getproperty),Vec{4, Float64},Symbol})   # time: 0.072291315
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(+),Vec2,Vec2})   # time: 0.070637785
    Base.precompile(Tuple{Type{ShaderInterface},ExecutionModel,Vector{StorageClass}})   # time: 0.06914336
    Base.precompile(Tuple{typeof(add_type_layouts!),IR,VulkanLayout})   # time: 0.06904514
    Base.precompile(Tuple{typeof(extract_bytes),Vec{2, Int64}})   # time: 0.06770289
    Base.precompile(Tuple{Type{DeltaGraph}})   # time: 0.06364
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ExecutionMode,Type})   # time: 0.06177094
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ImageFormat,Type})   # time: 0.057609532
    Base.precompile(Tuple{typeof(isapprox),Module,Module})   # time: 0.055835865
    Base.precompile(Tuple{typeof(show),IOContext{IOBuffer},ControlTree})   # time: 0.052713297
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:storage_classes, :variable_decorations, :type_metadata, :features), Tuple{Vector{StorageClass}, Dictionary{Int64, Decorations}, Dictionary{DataType, Metadata}, SupportedFeatures}},Type{ShaderInterface}})   # time: 0.04721367
    Base.precompile(Tuple{typeof(sin),Float32})   # time: 0.047126733
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,SourceLanguage,Type})   # time: 0.046722382
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Decoration,Type})   # time: 0.044338387
    Base.precompile(Tuple{typeof(compact),DeltaGraph{Int64}})   # time: 0.043653257
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(/),Float64,Vec{2, UInt32}})   # time: 0.043188006
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,ExecutionModel,Type})   # time: 0.042958725
    Base.precompile(Tuple{typeof(exp),Float32})   # time: 0.041435484
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,MemoryModel,Type})   # time: 0.04088113
    Base.precompile(Tuple{typeof(getindex),Mat{2, 2, Float64},Int64,Int64})   # time: 0.040290475
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,AddressingModel,Type})   # time: 0.040003788
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, PointerType}})   # time: 0.039898645
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Dim,Type})   # time: 0.03939687
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,StorageClass,Type})   # time: 0.039336167
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,FunctionControl,Type})   # time: 0.03929606
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,SelectionControl,Type})   # time: 0.039097693
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,LoopControl,Type})   # time: 0.03908126
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,Capability,Type})   # time: 0.038985375
    Base.precompile(Tuple{typeof(validate),IR})   # time: 0.03866151
    Base.precompile(Tuple{typeof(convert),Type{Vec{2, Int16}},Vec{2, Int64}})   # time: 0.038225606
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,SSAValue,Id})   # time: 0.036042567
    Base.precompile(Tuple{typeof(isapprox),PhysicalModule,PhysicalModule})   # time: 0.03590208
    Base.precompile(Tuple{typeof(invalidate_all!),SPIRVInterpreter})   # time: 0.03468419
    Base.precompile(Tuple{typeof(rem_vertex!),DeltaGraph{Int64},Int64})   # time: 0.03411251
    Base.precompile(Tuple{typeof(align),Vector{UInt8},StructType,IR})   # time: 0.033621464
    Base.precompile(Tuple{typeof(decorate!),Decorations,Decoration,Int64})   # time: 0.03309446
    Base.precompile(Tuple{typeof(compute_stride),StructType,IR,VulkanLayout})   # time: 0.032839704
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,StructType,Set{Any},Bool})   # time: 0.032697532
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,UInt32,Literal})   # time: 0.032685358
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},AddressingModel})   # time: 0.031594764
    let fbody = try Base.bodyfunction(which(spir_type, (Type,IR,))) catch missing end
    if !ismissing(fbody)
        precompile(fbody, (Bool,Nothing,typeof(spir_type),Type,IR,))
    end
end   # time: 0.030825078
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,SSAValue,String})   # time: 0.030274043
    Base.precompile(Tuple{typeof(reinterpret_spirv),Type{Vector{Vec{2, Int64}}},AbstractArray{UInt8}})   # time: 0.0293315
    Base.precompile(Tuple{Type{Vec2},Int64,Vararg{Int64}})   # time: 0.029244682
    Base.precompile(Tuple{typeof(log),Float32})   # time: 0.028887982
    Base.precompile(Tuple{SampledImage{Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4}},Vec2})   # time: 0.028766422
    Base.precompile(Tuple{typeof(getproperty),Vec4,Symbol})   # time: 0.028141754
    Base.precompile(Tuple{typeof(getindex),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Int64,Int64})   # time: 0.027964607
    Base.precompile(Tuple{typeof(emit!),IR,PointerType})   # time: 0.02685908
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, FunctionType}})   # time: 0.026602631
    Base.precompile(Tuple{typeof(CompositeConstruct),Type{Mat{2, 2, Float64}},Vec{2, Float64},Vec{2, Float64}})   # time: 0.02562266
    Base.precompile(Tuple{typeof(parse),Type{Module},String})   # time: 0.025607208
    Base.precompile(Tuple{typeof(acyclic_region),DeltaGraph{Int64},Int64})   # time: 0.024901433
    Base.precompile(Tuple{typeof(emit_nodes!),FunctionDefinition,IR,IRMapping,SPIRVTarget,Vector{UnitRange{Int64}},Vector{Int64},Set{Graphs.SimpleGraphs.SimpleEdge{Int64}}})   # time: 0.024335269
    Base.precompile(Tuple{typeof(show),IOBuffer,MIME{Symbol("text/plain")},IR})   # time: 0.023967113
    Base.precompile(Tuple{typeof(getindex),Pointer{Tuple{Int64, Int64, Int64}},Int64})   # time: 0.023137236
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, ArrayType}})   # time: 0.021984106
    Base.precompile(Tuple{Type{SPIRVInterpreter}})   # time: 0.02148773
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, ImageType}})   # time: 0.021216327
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},String})   # time: 0.02114757
    Base.precompile(Tuple{Type{Instruction},OpCode,SSAValue,SSAValue,Core.SSAValue,Vararg{Any}})   # time: 0.02087517
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SourceLanguage,Vararg{Any}})   # time: 0.02075683
    Base.precompile(Tuple{Type{Instruction},OpCode,SSAValue,SSAValue,FunctionControl,Vararg{Any}})   # time: 0.020614056
    Base.precompile(Tuple{typeof(emit_inst!),IR,IRMapping,SPIRVTarget,FunctionDefinition,Expr,Type,Block})   # time: 0.020356538
    Base.precompile(Tuple{typeof(cyclic_region),DeltaGraph{Int64},Int64})   # time: 0.020138508
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, Variable}})   # time: 0.019937454
    Base.precompile(Tuple{typeof(extract_bytes),Vector{Vec{2, Int64}}})   # time: 0.019461816
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,StructType,Vector{StorageClass},Bool})   # time: 0.018855901
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec{2, Float64},Float32})   # time: 0.018617008
    Base.precompile(Tuple{typeof(reinterpret_spirv),Type{Vec{2, Int64}},AbstractArray{UInt8}})   # time: 0.01833097
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SSAValue,Vararg{Any}})   # time: 0.018121844
    Base.precompile(Tuple{typeof(decorate!),Metadata,Int64,Decoration,Int64})   # time: 0.017593963
    Base.precompile(Tuple{typeof(emit!),IR,SPIRType})   # time: 0.01733935
    let fbody = try Base.bodyfunction(which(spir_type, (Type,Nothing,))) catch missing end
    if !ismissing(fbody)
        precompile(fbody, (Bool,Nothing,typeof(spir_type),Type,Nothing,))
    end
end   # time: 0.01677857
    Base.precompile(Tuple{Type{Instruction},OpCode,SSAValue,SSAValue,Float32})   # time: 0.016673412
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec2,Vec{2, Int64}})   # time: 0.016548602
    Base.precompile(Tuple{Type{Instruction},OpCode,SSAValue,SSAValue,Int32})   # time: 0.016217947
    Base.precompile(Tuple{Type{Instruction},OpCode,SSAValue,SSAValue,SSAValue,Vararg{SSAValue}})   # time: 0.015886867
    Base.precompile(Tuple{typeof(append_debug_annotations!),Vector{Instruction},SSAValue,Metadata})   # time: 0.015520762
    Base.precompile(Tuple{typeof(flow_through),Function,ControlFlowGraph{Graphs.SimpleGraphs.SimpleEdge{Int64}, Int64, DeltaGraph{Int64}},Int64})   # time: 0.015448241
    Base.precompile(Tuple{typeof(*),Int64,Vec2})   # time: 0.014125902
    Base.precompile(Tuple{typeof(getindex),Mat{4, 4, Float64},Int64,Int64})   # time: 0.013939214
    Base.precompile(Tuple{typeof(==),PhysicalModule,PhysicalModule})   # time: 0.013839594
    Base.precompile(Tuple{typeof(decorate!),Decorations,Decoration,Int64,Int64,Int64})   # time: 0.013223582
    Base.precompile(Tuple{Type{StructType},Vector{ScalarType}})   # time: 0.013056533
    Base.precompile(Tuple{typeof(similar),Mat{2, 2, Float64}})   # time: 0.012957677
    Base.precompile(Tuple{typeof(==),AnnotatedFunction,AnnotatedFunction})   # time: 0.01277423
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,VoidType})   # time: 0.012693606
    Base.precompile(Tuple{typeof(reinterpret_spirv),Type{Vector{Vec{2, Int64}}},Vector{UInt8}})   # time: 0.01235398
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, FloatType}})   # time: 0.011936687
    Base.precompile(Tuple{Type{Arr{Float32}},Float64,Float64,Float64,Float64,Float64})   # time: 0.011727574
    Base.precompile(Tuple{typeof(emit_argument),IndentedIO{IOContext{IOBuffer}},Int64,String,Literal})   # time: 0.011703864
    Base.precompile(Tuple{typeof(extract_bytes),Int32})   # time: 0.011611221
    Base.precompile(Tuple{typeof(size),Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4},Int64})   # time: 0.011608715
    Base.precompile(Tuple{Type{StructType},Vector{FloatType}})   # time: 0.011278179
    Base.precompile(Tuple{typeof(isapprox),StructType,StructType})   # time: 0.011066154
    Base.precompile(Tuple{typeof(common_ancestor),DominatorTree,Vector{DominatorTree}})   # time: 0.010981087
    Base.precompile(Tuple{Type{StructType},Vector{IntegerType}})   # time: 0.010945617
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,SSAValue,Int64,Vararg{Int64}})   # time: 0.010849545
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, VectorType}})   # time: 0.010820292
    Base.precompile(Tuple{Type{StructType},Vector{ArrayType}})   # time: 0.010805243
    Base.precompile(Tuple{typeof(extract_bytes),Int64})   # time: 0.01076792
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},MemoryAccess})   # time: 0.01049635
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},OpCodeGLSL})   # time: 0.010473203
    Base.precompile(Tuple{typeof(get_signature),Expr})   # time: 0.010463027
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},MemoryModel})   # time: 0.010337616
    Base.precompile(Tuple{typeof(align),Vector{UInt8},Vector{Int64},Vector{Int64}})   # time: 0.010300952
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},FunctionControl})   # time: 0.010199345
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ExecutionMode})   # time: 0.010160379
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},StorageClass})   # time: 0.010159504
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},LoopControl})   # time: 0.010110043
    Base.precompile(Tuple{Type{SPIRVInterpreter},Vector{Core.MethodTable}})   # time: 0.010079196
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ExecutionModel})   # time: 0.010079109
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},SelectionControl})   # time: 0.010035994
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},SourceLanguage})   # time: 0.010024392
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Dim})   # time: 0.009999299
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},ImageFormat})   # time: 0.009957187
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},BuiltIn})   # time: 0.009909471
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Capability})   # time: 0.009890462
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},Decoration})   # time: 0.009841017
    Base.precompile(Tuple{typeof(extract_bytes),Int8})   # time: 0.009594599
    Base.precompile(Tuple{typeof(satisfy_requirements!),IR,SupportedFeatures})   # time: 0.009438689
    Base.precompile(Tuple{Type{StructType},Vector{MatrixType}})   # time: 0.009349903
    isdefined(SPIRV, Symbol("#_decorate!#63")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#_decorate!#63")),Decoration,Vararg{Any}})   # time: 0.009334416
    Base.precompile(Tuple{Type{FunctionType},VoidType,Vector{PointerType}})   # time: 0.009126965
    Base.precompile(Tuple{Type{Vec2},Float64,Float64})   # time: 0.008735023
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, StructType}})   # time: 0.00861064
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,FunctionType})   # time: 0.008144184
    Base.precompile(Tuple{typeof(validate),Shader})   # time: 0.007989034
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,FunctionType})   # time: 0.00782299
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.00777242
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007758146
    Base.precompile(Tuple{Type{Vec2},Int64,Int64})   # time: 0.007752334
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007726552
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007711634
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007675371
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007667765
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007663165
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007605444
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64},Pair{Int64, Int64}})   # time: 0.007591546
    Base.precompile(Tuple{typeof(==),ControlTree,ControlTree})   # time: 0.007478009
    Base.precompile(Tuple{Type{StackFrame},AnnotatedModule,SSAValue})   # time: 0.007414286
    Base.precompile(Tuple{typeof(mod),Float64,Float64})   # time: 0.007271718
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,SSAValue,SSAValue})   # time: 0.007250624
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,IntegerType,Set{Any},Bool})   # time: 0.007245323
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Int32,String})   # time: 0.007170998
    Base.precompile(Tuple{typeof(==),DeltaGraph{Int64},DeltaGraph{Int64}})   # time: 0.007151602
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,PointerType})   # time: 0.006988476
    Base.precompile(Tuple{typeof(parse),Type{SPIRType},Instruction,BijectiveMapping{SSAValue, SPIRType},BijectiveMapping{SSAValue, Constant}})   # time: 0.006920848
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SSAValue,Decoration,UInt32})   # time: 0.006750289
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SSAValue,UInt32,Decoration,UInt32})   # time: 0.006731192
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SSAValue,Decoration})   # time: 0.006628521
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SSAValue,UInt32,Decoration})   # time: 0.006622554
    Base.precompile(Tuple{Type{DeltaGraph},Int64,Pair{Int64, Int64},Vararg{Pair{Int64, Int64}}})   # time: 0.00660326
    Base.precompile(Tuple{typeof(getindex),Arr{3, Float64},Int64})   # time: 0.006551843
    Base.precompile(Tuple{typeof(add_align_operands!),IR,FunctionDefinition,VulkanLayout})   # time: 0.006211386
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, IntegerType}})   # time: 0.006148688
    Base.precompile(Tuple{Type{IR}})   # time: 0.006068074
    Base.precompile(Tuple{typeof(getindex),Vec{4, Float64},Int64})   # time: 0.005698705
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Capability,String})   # time: 0.005523783
    Base.precompile(Tuple{typeof(getoffsets),TypeInfo,DataType})   # time: 0.005379049
    Base.precompile(Tuple{typeof(getindex),Arr{4, Float64},Int64})   # time: 0.005374446
    Base.precompile(Tuple{typeof(append_decorations!),Vector{Instruction},SSAValue,Metadata})   # time: 0.005336726
    Base.precompile(Tuple{typeof(getoffsets),DataType})   # time: 0.005287266
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(+),Vec3,Vec3})   # time: 0.005157964
    Base.precompile(Tuple{typeof(throw_compilation_error),ErrorException,NamedTuple{(:jinst, :jtype), Tuple{Expr, DataType}}})   # time: 0.004976067
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(/),Vec2,Vec{2, Int64}})   # time: 0.004958592
    Base.precompile(Tuple{Type{ImageType},Instruction,FloatType})   # time: 0.004948038
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,SourceLanguage,String})   # time: 0.004913377
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Dim,String})   # time: 0.004838202
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,MemoryAccess,String})   # time: 0.004811884
    isdefined(SPIRV, Symbol("#callback#260")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#callback#260")),MethodInstance,UInt32})   # time: 0.004744655
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,OpCodeGLSL,String})   # time: 0.004741408
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(-),Vec2,Vec2})   # time: 0.004730227
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,LoopControl,String})   # time: 0.004726043
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,SelectionControl,String})   # time: 0.004718599
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ImageFormat,String})   # time: 0.004707396
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ExecutionMode,String})   # time: 0.004675067
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Decoration,String})   # time: 0.004669332
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,FunctionControl,String})   # time: 0.004662812
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,UInt32,String})   # time: 0.004648847
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,MemoryModel,String})   # time: 0.004640317
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,ExecutionModel,String})   # time: 0.004639439
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,StorageClass,String})   # time: 0.004625839
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,BuiltIn,String})   # time: 0.004621014
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,AddressingModel,String})   # time: 0.0046151
    Base.precompile(Tuple{Core.kwftype(typeof(Type)),NamedTuple{(:execution_model, :storage_classes, :variable_decorations), Tuple{ExecutionModel, Vector{StorageClass}, Dictionary{Int64, Decorations}}},Type{ShaderInterface}})   # time: 0.004609861
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,StructType})   # time: 0.004491228
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,ArrayType,Set{StorageClass},Bool})   # time: 0.004484161
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,MatrixType})   # time: 0.004395435
    Base.precompile(Tuple{typeof(promote_to_interface_block),VectorType,StorageClass})   # time: 0.004357693
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,VectorType})   # time: 0.004185591
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Float32,String})   # time: 0.004185277
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,Int64,String})   # time: 0.004057515
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,ArrayType})   # time: 0.004025144
    Base.precompile(Tuple{Core.kwftype(typeof(findall)),NamedTuple{(:limit,), Tuple{Int64}},typeof(Core.Compiler.findall),Type{<:Tuple{Any, Bool}},NOverlayMethodTable})   # time: 0.004007582
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,IntegerType})   # time: 0.003969261
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,FloatType})   # time: 0.003958081
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,SampledImageType})   # time: 0.003911521
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,IntegerType,Set{StorageClass},Bool})   # time: 0.003898802
    Base.precompile(Tuple{typeof(storage_class),Core.SSAValue,IR,IRMapping,FunctionDefinition})   # time: 0.003814388
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,VoidType})   # time: 0.003734159
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,BooleanType})   # time: 0.003732562
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,SamplerType})   # time: 0.003704973
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,StructType})   # time: 0.003680366
    Base.precompile(Tuple{Type{Vec{2, UInt32}},Int64,Vararg{Int64}})   # time: 0.003674425
    Base.precompile(Tuple{typeof(image_type),ImageFormat,Dim,Int64,Bool,Bool,Int64})   # time: 0.00365899
    Base.precompile(Tuple{typeof(-),Vec{3, Float64},Vec{3, Float64}})   # time: 0.003631871
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,FloatType})   # time: 0.003613854
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,ArrayType})   # time: 0.003594075
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,MatrixType})   # time: 0.003591858
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,VectorType})   # time: 0.00357285
    Base.precompile(Tuple{Type{Arr{Float32}},Float64,Vararg{Float64}})   # time: 0.003572186
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,PointerType})   # time: 0.003569812
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,Constant})   # time: 0.003536044
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,IntegerType})   # time: 0.003534327
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,Variable})   # time: 0.003526022
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,SampledImageType})   # time: 0.003451914
    Base.precompile(Tuple{typeof(setindex!),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Vec4,Int64,Int64})   # time: 0.003407538
    Base.precompile(Tuple{typeof(*),Vec{3, Float64},Vec{3, Float64}})   # time: 0.003406705
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,ImageType})   # time: 0.003381756
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,BooleanType})   # time: 0.003361322
    Base.precompile(Tuple{typeof(setindex!),Mat{2, 2, Float64},Float64,Int64,Int64})   # time: 0.003328414
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, SPIRType},SSAValue,SamplerType})   # time: 0.003196681
    Base.precompile(Tuple{typeof(getindex),Arr{1, Float32},UInt32})   # time: 0.003195607
    Base.precompile(Tuple{Type{ShaderInterface},ExecutionModel,Vector{StorageClass},Dictionary{Int64, Decorations}})   # time: 0.003178992
    Base.precompile(Tuple{typeof(add_extra_operands!),Vector{OperandInfo},Int64,String,String})   # time: 0.003166266
    Base.precompile(Tuple{typeof(getindex),Vec2,UInt32})   # time: 0.003165514
    Base.precompile(Tuple{typeof(similar),Arr{4, Float64}})   # time: 0.003109464
    Base.precompile(Tuple{typeof(setindex!),Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4},Vec4,Int64})   # time: 0.003092224
    Base.precompile(Tuple{typeof(insert!),BijectiveMapping{SSAValue, Any},SSAValue,ImageType})   # time: 0.003091006
    Base.precompile(Tuple{typeof(setindex!),Vec{4, Float64},Int64,Int64})   # time: 0.003085041
    Base.precompile(Tuple{typeof(setindex!),Arr{4, Float64},Int64,Int64})   # time: 0.00283115
    Base.precompile(Tuple{Type{VulkanLayout}})   # time: 0.002825787
    Base.precompile(Tuple{Type{ControlTree},Int64,RegionType})   # time: 0.002818292
    Base.precompile(Tuple{typeof(eachindex),Vec{2, Int64}})   # time: 0.00278664
    Base.precompile(Tuple{Type{ControlTree},Int64,RegionType,Tuple{ControlTree, ControlTree, ControlTree}})   # time: 0.002777187
    Base.precompile(Tuple{typeof(eachindex),Mat{2, 2, Float64}})   # time: 0.002635854
    Base.precompile(Tuple{typeof(has_decoration),Metadata,Int64,Decoration})   # time: 0.002618384
    Base.precompile(Tuple{typeof(has_decoration),Decorations,Decoration})   # time: 0.002496776
    Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),typeof(*),Vec3,Float32})   # time: 0.002471254
    Base.precompile(Tuple{typeof(getindex),Vec{3, Float64},Int64})   # time: 0.002468946
    Base.precompile(Tuple{typeof(load_expr),Expr})   # time: 0.002404905
    Base.precompile(Tuple{typeof(getindex),Arr{5, Float32},UInt32})   # time: 0.002386467
    Base.precompile(Tuple{typeof(backedges),DeltaGraph{Int64}})   # time: 0.002355373
    Base.precompile(Tuple{typeof(cap_world),UInt64,UInt32})   # time: 0.002338684
    Base.precompile(Tuple{typeof(source_version),SourceLanguage,UInt32})   # time: 0.00224083
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{SSAValue, SPIRType},SampledImageType})   # time: 0.002186785
    Base.precompile(Tuple{typeof(==),Instruction,Instruction})   # time: 0.002116921
    Base.precompile(Tuple{typeof(getindex),Pointer{Vector{Int64}},Int64})   # time: 0.002115104
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,FloatType,Set{Any},Bool})   # time: 0.002113331
    Base.precompile(Tuple{typeof(merge),Metadata,Metadata})   # time: 0.002016073
    Base.precompile(Tuple{Type{StructType},Vector{SPIRType}})   # time: 0.001990066
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,StructType,Set{StorageClass},Bool})   # time: 0.001919752
    Base.precompile(Tuple{typeof(copyto!),Vec2,Vec2})   # time: 0.001919539
    Base.precompile(Tuple{typeof(payload_size),Vec{2, Int64}})   # time: 0.001917881
    Base.precompile(Tuple{typeof(haskey),BijectiveMapping{SSAValue, SPIRType},SamplerType})   # time: 0.00191507
    Base.precompile(Tuple{typeof(alignment),VulkanLayout,FloatType,Set{StorageClass},Bool})   # time: 0.00189304
    isdefined(SPIRV, Symbol("#318#329")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#318#329")),Expr})   # time: 0.001889562
    Base.precompile(Tuple{Type{SSAValue},IR,VoidType})   # time: 0.001867166
    Base.precompile(Tuple{Type{Pointer{Vector{Int64}}},UInt64})   # time: 0.001853382
    Base.precompile(Tuple{Type{Vec{1, Float64}},Float64})   # time: 0.001737321
    isdefined(SPIRV, Symbol("#70#71")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#70#71")),VectorType})   # time: 0.001709537
    isdefined(SPIRV, Symbol("#70#71")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#70#71")),ArrayType})   # time: 0.001701223
    isdefined(SPIRV, Symbol("#70#71")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#70#71")),MatrixType})   # time: 0.001682659
    Base.precompile(Tuple{typeof(Base.Broadcast.materialize!),Vec3,Broadcasted{BroadcastStyleSPIRV{Vec3}, Tuple{Base.OneTo{Int64}}, typeof(identity), Tuple{Vec3}}})   # time: 0.001670228
    Base.precompile(Tuple{Type{Vec3},Int64,Vararg{Int64}})   # time: 0.001630724
    Base.precompile(Tuple{Type{SSAValue},IR,IntegerType})   # time: 0.001614362
    Base.precompile(Tuple{typeof(compute_minimal_size),StructType,IR,VulkanLayout})   # time: 0.001586767
    Base.precompile(Tuple{Type{SSAValue},IR,StructType})   # time: 0.001574539
    Base.precompile(Tuple{typeof(payload_sizes),Type})   # time: 0.001572894
    Base.precompile(Tuple{typeof(promote_to_interface_block),IntegerType,StorageClass})   # time: 0.001565543
    Base.precompile(Tuple{Type{SSAValue},IR,FloatType})   # time: 0.00155261
    Base.precompile(Tuple{typeof(align),Vector{UInt8},StructType,Vector{Int64}})   # time: 0.001519397
    Base.precompile(Tuple{typeof(setindex!),Vec{4, Float64},Vec{4, Float64}})   # time: 0.001513883
    Base.precompile(Tuple{typeof(setindex!),Arr{4, Float64},Arr{4, Float64}})   # time: 0.00151137
    Base.precompile(Tuple{typeof(setindex!),Mat{2, 2, Float64},Mat{2, 2, Float64}})   # time: 0.001499027
    Base.precompile(Tuple{typeof(setindex!),Vec4,Vec4})   # time: 0.001488552
    Base.precompile(Tuple{typeof(clamp),Float32,Float32,Float32})   # time: 0.001461026
    Base.precompile(Tuple{Type{SSAValue},IR,ImageType})   # time: 0.001441331
    Base.precompile(Tuple{SampledImage{Image{ImageFormatRgba32f, Dim2D, 0, false, false, 1, Vec4}},Float32,Float32})   # time: 0.001412754
    isdefined(SPIRV, Symbol("#315#326")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#315#326")),Symbol})   # time: 0.001410971
    Base.precompile(Tuple{Type{IntegerType},UInt32,UInt32})   # time: 0.001400022
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, MatrixType}})   # time: 0.001365393
    isdefined(SPIRV, Symbol("#322#333")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#322#333")),Symbol})   # time: 0.001331632
    isdefined(SPIRV, Symbol("#319#330")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#319#330")),Symbol})   # time: 0.00132701
    Base.precompile(Tuple{typeof(setproperty!),Vec4,Symbol,UInt32})   # time: 0.001312103
    isdefined(SPIRV, Symbol("#67#68")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#67#68")),SSAValue})   # time: 0.001280004
    Base.precompile(Tuple{typeof(eachindex),Arr{5, Float32}})   # time: 0.001277318
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SSAValue,UInt32,String})   # time: 0.001250272
    isdefined(SPIRV, Symbol("#85#86")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#85#86")),Pair{SSAValue, VoidType}})   # time: 0.001245507
    Base.precompile(Tuple{typeof(clamp),Float64,Float64,Float64})   # time: 0.001243184
    Base.precompile(Tuple{Type{Decorations}})   # time: 0.001238355
    Base.precompile(Tuple{SampledImage{Image{ImageFormatRgba16f, Dim2D, 0, false, false, 1, Vec4}},Float32,Float32})   # time: 0.001235168
    Base.precompile(Tuple{Type{Pointer},Base.RefValue{Tuple{Int64, Int64, Int64}}})   # time: 0.001227286
    Base.precompile(Tuple{typeof(storage_class),Core.Argument,IR,IRMapping,FunctionDefinition})   # time: 0.00122163
    isdefined(SPIRV, Symbol("#224#229")) && Base.precompile(Tuple{getfield(SPIRV, Symbol("#224#229")),Int64})   # time: 0.001185123
    Base.precompile(Tuple{Type{Instruction},OpCode,Nothing,Nothing,SSAValue,String})   # time: 0.001183786
    Base.precompile(Tuple{typeof(add_operand!),Vector{UInt32},UInt32})   # time: 0.001151798
    Base.precompile(Tuple{typeof(throw_compilation_error),CompilationError,NamedTuple{(:mi,), Tuple{MethodInstance}}})   # time: 0.001151514
    Base.precompile(Tuple{typeof(emit!),IR,Constant})   # time: 0.001151258
    Base.precompile(Tuple{typeof(load_if_variable!),Block,IR,IRMapping,FunctionDefinition,Core.SSAValue})   # time: 0.001108458
    Base.precompile(Tuple{Type{ImageType},FloatType,Dim,UInt32,UInt32,UInt32,Bool,ImageFormat,Nothing})   # time: 0.001044049
    Base.precompile(Tuple{typeof(iterate),BijectiveMapping{SSAValue, FunctionDefinition}})   # time: 0.001006764
    Base.precompile(Tuple{typeof(getindex),AnnotatedModule,SSAValue})   # time: 0.001001024
