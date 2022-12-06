include("../utils.jl")
using .Fileio

raw_cont = read_txt(ARGS[1] * ".txt")

##################
function get_marker_pos(communication, unique_markers = 4)
	buffer = []
	#index = 0
	for i in 1:length(communication)

		# the character does not appear, append to end
		push!(buffer, communication[i])

		# check if just added element is repeated
		# println(indexin(communication[i], buffer)[1] == length(buffer))
		if indexin(communication[i], buffer)[1] == length(buffer)

			if length(buffer) == unique_markers
				return i
			end
		else 
			#the character appears, remove from beginning until no repeated character
			while length(unique(buffer)) != length(buffer)
				popfirst!(buffer)
			end
		end
	end
	throw("no marker found")
end
##################

println("example 1")

if ARGS[1] == "example"
	for communication = eachsplit(raw_cont, "\n")
		println(get_marker_pos(communication))
	end
end

##################
##### PART 1 #####
##################

if ARGS[1] == "data"
	solution = get_marker_pos(raw_cont)
	println("part 1: $solution")
end

##################
##### PART 2 #####
##################

println("example 1")

if ARGS[1] == "example"
	for communication = eachsplit(raw_cont, "\n")
		println(get_marker_pos(communication, 14))
	end
end

if ARGS[1] == "data"
	solution = get_marker_pos(raw_cont, 14)
	println("part 2: $solution")
end
