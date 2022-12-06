include("../utils.jl")
using .Fileio

raw_cont::String = read_txt(ARGS[1] * ".txt")

##################
function get_marker_pos(communication::String, unique_markers::Int = 4)
	buffer::Array{Char,1} = []
	#index = 0
	for i::Int in 1:length(communication)

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


if ARGS[1] == "example"
	println("example 1")
	for communication::String = eachsplit(raw_cont, "\n")
		println(get_marker_pos(communication))
	end
end

##################
##### PART 1 #####
##################

if ARGS[1] == "data"
	solution::Int = get_marker_pos(raw_cont)
	println("part 1: $solution")
end

##################
##### PART 2 #####
##################


if ARGS[1] == "example"
	println("example 2")
	for communication::String = eachsplit(raw_cont, "\n")
		println(get_marker_pos(communication, 14))
	end
end

if ARGS[1] == "data"
	solution::Int = get_marker_pos(raw_cont, 14)
	println("part 2: $solution")
end
