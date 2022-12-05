include("../utils.jl")
using .Fileio

raw_cont = read_txt(ARGS[1] * ".txt")

##################
##### PART 1 #####
##################
solution = ""

file_cont = split(raw_cont, "\n\n")

# 2 6 10
piles = Dict()
for crate_storage = eachsplit(file_cont[1], "\n")
	global piles

	# println(crate_storage)[1,3]
	i = 1
	pos = 2
	# iterate crate storage lines
	while pos < length(crate_storage)

		crate = crate_storage[pos]
		if(crate != ' ' && !is_number(crate))

			# create dict key in case it does not exist
			if !haskey(piles, i)
				piles[i] = []
			end
	
			# add crate to pile
			piles[i] = push!(piles[i], crate)
		end

		pos = 2 + i * 4
		i += 1
	end
end

piles_dup = deepcopy(piles)


for command = eachsplit(file_cont[2], "\n")
	splitted_comm = split(command, " ")
	how_many = parse(Int, splitted_comm[2])
	from_pile = parse(Int, splitted_comm[4])
	to_pile = parse(Int, splitted_comm[6])

	for i = 1:how_many
		pushfirst!(piles[to_pile], popfirst!(piles[from_pile]))
	end
end


for i in 1:maximum(keys(piles))
	global solution *= piles[i][1]
end

println("part 1: $solution")


# ##################
# ##### PART 2 #####
# ##################

# println(piles_dup)

solution = ""

for command = eachsplit(file_cont[2], "\n")
	splitted_comm = split(command, " ")
	how_many = parse(Int, splitted_comm[2])
	from_pile = parse(Int, splitted_comm[4])
	to_pile = parse(Int, splitted_comm[6])

	buffer = []
	for i = 1:how_many
		pushfirst!(buffer, popfirst!(piles_dup[from_pile]))
	end
	for i = 1:how_many
		pushfirst!(piles_dup[to_pile], popfirst!(buffer))
	end
end


for i in 1:maximum(keys(piles_dup))
	global solution *= piles_dup[i][1]
end

println("part 2: $solution")
