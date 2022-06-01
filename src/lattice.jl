mutable struct Lattice{T, N, A <: AbstractArray{T,N}} <: AbstractArray{T,N}
    linearsize::Int
    iterations::Int
    arr::A
end
function Lattice(linearsize)
    arr = Array{Int}(rand([1,-1], linearsize, linearsize))
    return Lattice(linearsize, 1, arr)
end
Base.IndexStyle(::Type{<:Lattice}) = IndexLinear()
Base.size(x::Lattice) = size(x.arr)
@inline Base.@propagate_inbounds Base.getindex(x::Lattice, i::Int) = getindex(x.arr, i)
@inline Base.@propagate_inbounds Base.setindex!(x::Lattice, v, i::Int) = setindex!(x.arr, v, i)

function iterationstep!(x::Lattice)
    x.iterations += 1
    return x
end