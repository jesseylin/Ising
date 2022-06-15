function wrap(index::CartesianIndex, linearsize)
	indexcopy = [Tuple(index)...]
	for j in eachindex(indexcopy)
        indexcopy[j] = mod(indexcopy[j], linearsize) == 0 ? linearsize : mod(indexcopy[j], linearsize) 
	end
	return CartesianIndex(Tuple(indexcopy))::typeof(index)
end

function Base.:+(x::CartesianIndex, y::CartesianIndex)
    if length(x) != length(y)
        throw(DimensionMismatch("Cannot add."))
    end
end