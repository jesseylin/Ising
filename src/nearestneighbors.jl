function getneighbors(site::CartesianIndex, linearsize)
	indexcopy = [Tuple(site)...]
	for index in indexcopy
		if (index > linearsize) || (index < 1)
			throw(ArgumentError("Need to wrap site before using getneighbors"))
		end
	end
	neighbors = Set()

	for δ in [(1,0), (0,1)]
        δ = CartesianIndex(δ)
        push!(neighbors, wrap(site + δ, linearsize))
		push!(neighbors, wrap(site - δ,linearsize))
	end
    return neighbors
end

function siteenergy(x::Lattice, site, J)
	neighbors = getneighbors(site, x.linearsize)
	E = 0
	for index in neighbors
		E += J*x[index]*x[site]
	end
	return E
end

function energy(x::Lattice, J)
	sites = CartesianIndices(x)
	E = 0.

	for s in sites
		E += siteenergy(x, s, J)
	end
	E /= 2 # divide for overcounting
	return E
end