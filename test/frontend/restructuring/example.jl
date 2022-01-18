using SPIRV

for sym in [:a, :b, :c, :d, :e]
  @eval $sym() = Base.invokelatest(Nothing, ())
end

a_to_c() = Base.invokelatest(rand, Bool)
d_to_b() = Base.invokelatest(rand, Bool)

function some_program()
  a()
  if !a_to_c()
    while true
      b()
      d()
      !d_to_b() && break
    end
  else
    c()
  end
  e()
end

function f(x::AbstractFloat)
  if x == 2 || x == 3
    3.0
  else
    4.0
  end
end

cfg = CFG(f, Tuple{Float64})
modified = merge_return_blocks(cfg)
replace_code!(cfg.mi, modified.code)
cfg2 = infer(cfg)
cfg2.code
cfg.mi.uninferred
cfg.code
CFG(cfg.mi).code

using Plots, GraphRecipes

macro plot_cfg(ex)
  quote
    cfg = CFG(@code_lowered $ex)
    plot(cfg.graph, names = 1:length(cfg.graph), nodesize = 0.5)
  end
end

plot(cfg.graph, names = 1:length(cfg.graph), nodesize = 0.5)
plot(cfg2.graph, names = 1:length(cfg2.graph), nodesize = 0.3)
0

#=

HEAD-CONTROLLED VERSION

%49 = OpLabel
      OpLoopMerge %51 %52 None               ; structured loop
      OpBranch %53
%53 = OpLabel
%54 = OpLoad %16 %48
%56 = OpSLessThan %25 %54 %55                ; i < 4 ?
      OpBranchConditional %56 %50 %51        ; body or break
%50 = OpLabel                                ; body
%58 = OpLoad %7 %57
%59 = OpLoad %7 %31
%60 = OpFMul %7 %59 %58
      OpStore %31 %60
      OpBranch %52
%52 = OpLabel                                ; continue target
%61 = OpLoad %16 %48
%62 = OpIAdd %16 %61 %21                     ; ++i
      OpStore %48 %62
      OpBranch %49                           ; loop back
%51 = OpLabel                                ; loop merge point
      OpReturn

TAIL-CONTROLLED VERSION

%49 = OpLabel
      OpLoopMerge %51 %52 None               ; structured loop
      OpBranch %50
%53 = OpLabel
%54 = OpLoad %16 %48
%56 = OpSLessThan %25 %54 %55                ; i < 4 ?
      OpBranchConditional %56 %52 %51        ; continue or break
%50 = OpLabel                                ; body
%58 = OpLoad %7 %57
%59 = OpLoad %7 %31
%60 = OpFMul %7 %59 %58
      OpStore %31 %60
      OpBranch %53
%52 = OpLabel                                ; continue target
%61 = OpLoad %16 %48
%62 = OpIAdd %16 %61 %21                     ; ++i
      OpStore %48 %62
      OpBranch %49                           ; loop back
%51 = OpLabel                                ; loop merge point
      OpReturn




Some program:



=#
