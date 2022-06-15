module Ising

export Lattice, iterationstep!
export wrap
export getneighbors, siteenergy, energy
export update!, simulate!

include("lattice.jl")
include("periodicindices.jl")
include("nearestneighbors.jl")

function update!(lattice::Lattice, J)
    ϵ = rand()
    site_indices = CartesianIndices(lattice)
    rand_site = rand(site_indices)
    dE = siteenergy(lattice, rand_site, J)

    if (dE > 0) || (exp(dE) > ϵ)
        lattice[rand_site] *= -1
    end
    iterationstep!(lattice)

    return lattice
end

function simulate!(lattice::Lattice, J, steps)
    output_data = Array{eltype(lattice)}(undef, size(lattice)..., steps+1)

    output_data[:,:,1] = lattice.arr
    for i in 2:steps+1
        update!(lattice, J)
        output_data[:,:,i] = lattice.arr 
    end

    return output_data
end

end
