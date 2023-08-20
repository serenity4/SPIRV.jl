@enum MethodSelectionResult begin
  INVALID_SIGNATURE
  INVALID_WORLD
end

function matching_methods(@nospecialize(sig::Type), mt::MethodTable, lim::Int, include_ambiguous::Bool, world::UInt, range::WorldRange)
  unw = CC.unwrap_unionall(sig)
  unw <: Tuple || return INVALID_SIGNATURE
  unw === Tuple{} || unw === Tuple{Union{}} && return INVALID_SIGNATURE
  mt = @something(mt, @ccall(jl_method_table_for(unw::Any)::Any), Some(nothing))
  ml_matches(mt, sig, lim, include_ambiguous, true, world, range)
end

struct TypemapIntersectionEnv
  "Function to call on a match."
  f::Any
  "Type to match."
  target::Any
  "The `tparam0` for the vararg in type, if applicable (or `nothing`)."
  va::Optional{Any}
  search_slurp::Int
  range::WorldRange # required?
end

struct TypemapIntersectionResult
  intersected::Any
  env::Optional{Vector{Any}}
  is_subtype::Bool
end

struct MLMatchesEnv
  env::TypemapIntersectionEnv
  intersections::Int
  world::UInt
  lim::Int
  include_ambiguous::Bool
end

function ml_mtable_visitor(f, mt::MethodTable)
  env = TypemapIntersectionEnv()
  typemap_intersection_visitor()
end

const TupleType = DataType

function ml_matches(mt::MethodTable, @nospecialize(sig::TupleType), lim::Int, include_ambiguous::Bool, intersections::Bool, world::UInt, range::WorldRange)
  world > Core.Compiler.get_world_counter() && return INVALID_WORLD
  has_ambiguity = false
  unw = CC.unwrap_unionall(sig)
  @assert isa(unw, DataType)
  l = length(unw.parameters)
  va = nothing
  if l > 0
    va = unw.parameters[l]
    isa(va, Vararg) ? (va = CC.unwrapva(va)) : (va = nothing)
  end

  # Skipping cache lookups.

  # Skipping scanning through the method table.
end

#=

struct typemap_intersection_env;
typedef int (*jl_typemap_intersection_visitor_fptr)(jl_typemap_entry_t *l, struct typemap_intersection_env *closure);
struct typemap_intersection_env {
    // input values
    jl_typemap_intersection_visitor_fptr const fptr; // fptr to call on a match
    jl_value_t *const type; // type to match
    jl_value_t *const va; // the tparam0 for the vararg in type, if applicable (or NULL)
    size_t search_slurp;
    // output values
    size_t min_valid;
    size_t max_valid;
    jl_value_t *ti; // intersection type
    jl_svec_t *env; // intersection env (initialize to null to perform intersection without an environment)
    int issubty;    // if `a <: b` is true in `intersect(a,b)`
};

struct ml_matches_env {
      // inputs:
      struct typemap_intersection_env match;
      int intersections;
      size_t world;
      int lim;
      int include_ambiguous;
      // results:
      jl_value_t *t; // array of method matches
      jl_method_match_t *matc; // current working method match
  };


Matches:

Tuple{Int64, Real} # level = 1
Tuple{Real, Float64} # level = 2

Tuple{Int64, Float64} # 1
Tuple{Real, Real} # 0
Tuple{Int64, Any} # 0

Tuple{Real, Int64} fully covers Tuple{Any, Int64}
Tuple{Real, Real} fully covers Tuple{Any, Real}
Tuple{Real, Any} does not fully cover Tuple{Any, Real}
Tuple{Any, Union{Int64, String}} does not fully cover Tuple{Real, Int64}

=#
