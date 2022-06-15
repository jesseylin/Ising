using Ising
using Test, Random

@testset "Lattice sanity checks" begin
	a = Lattice(10)
	b = deepcopy(a)
	@test typeof(a) <: Lattice
	@test a[rand(eachindex(a))] in [1, -1]
	@test a.linearsize == size(a, 1)
	
	@test b == a
	@test iterationstep!(a).iterations == 2
	@test a.iterations != b.iterations
	
	b[1] *= -1
	@test a != b
end

# tests of periodicindices.jl
let
	linearsize = 10
	a = Lattice(linearsize)
	
	@testset "wrap sanity check" begin
		index = CartesianIndex((linearsize+1, linearsize+1))
		@test wrap(index, linearsize) == CartesianIndex((1,1))

		index = CartesianIndex((0,0))
		@test wrap(index, linearsize) == CartesianIndex((linearsize, linearsize))

		index = CartesianIndex(rand(linearsize:3*linearsize), -rand(linearsize:3*linearsize))
		index = wrap(index, linearsize)
		@test 1 <= index[1] <= linearsize
		@test 1 <= index[2] <= linearsize
		
	end

	@testset "Addition on CartesianIndex sanity check" begin
		x = CartesianIndex(1,1)
		y = CartesianIndex(1,1,1)
		@test_throws DimensionMismatch x + y

		x = CartesianIndex(1,1)
		y = CartesianIndex(2,2)
		@test x + y == CartesianIndex(3,3)
	end
end


# test of nearestneighbors.jl
let
	linearsize = 3
	a = Lattice(linearsize, 1, [1 1 1; 1 1 1; 1 1 1])
	J = -1 # ferromagnetic
	@testset "siteenergy sanity check" begin
		
		@test siteenergy(a, CartesianIndex(2,2), J) == -4
		a.arr = a.arr .* -1
		@test siteenergy(a, CartesianIndex(2,2), J) == -4
	end
end

let
	@testset "getneighbors sanity check" begin
		linearsize = 3
		
        site = CartesianIndex(2,2)
        @test Set(getneighbors(site, linearsize)) == Set([CartesianIndex(x) for x in [(1,2), (2,1), (2,3), (3,2)]])
		
		site = CartesianIndex(3,3)
        @test Set(getneighbors(site, linearsize)) == Set([CartesianIndex(x) for x in [(2,3), (3,2), (3,1), (1,3)]])

		site = CartesianIndex(0,0)
		@test_throws ArgumentError getneighbors(site, linearsize)
		
		site = CartesianIndex(1,linearsize+1)
		@test_throws ArgumentError getneighbors(site, linearsize)
	end
end


# test of Monte Carlo updating
let 
	@testset "update! sanity check" begin
		J = -1
		linearsize = 10
		lattice = Lattice(linearsize)
		orig_lattice = deepcopy(lattice)
		update!(lattice, J)
		@test lattice.iterations != orig_lattice.iterations

		lattice = Lattice(linearsize)
		orig_lattice = deepcopy(lattice)
		output_data = simulate!(lattice, J, 2)
		@test output_data[:,:,1] == orig_lattice
	end
end