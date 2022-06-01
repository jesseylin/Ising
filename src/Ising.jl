module Ising

export Lattice, iterationstep!
export wrap
export getneighbors, siteenergy

include("lattice.jl")
include("periodicindices.jl")
include("nearestneighbors.jl")

end
