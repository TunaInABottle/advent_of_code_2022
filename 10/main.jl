include("../utils.jl")
using .Fileio

raw_cont::String = read_txt(ARGS[1] * ".txt")


function cyclic_signal_append!(signal_strength, cycle_n, cycle_value)
	cycle_sampling = [20, 60, 100, 140, 180, 220]

	if indexin(cycle_n, cycle_sampling) .!= nothing
		println(cycle_n, " ", cycle_value)
		push!(signal_strength, cycle_value * cycle_n)
	end
end

##################
##### PART 1 #####
##################
cycle_n::Int = 0
registered_value::Int = 1
signal_strength::Array{Int} = []

for command::String = eachsplit(raw_cont, "\n")
	global cycle_n, registered_value, signal_strength
	command_args = split(command, " ")

	cycle_n += 1
	cyclic_signal_append!(signal_strength, cycle_n, registered_value)

	# if command_args[1] == "noop"
	# 	# println(command_args)
	# 	cyclic_signal_append!(signal_strength, cycle_n, registered_value)
	# end
	if command_args[1] == "addx"
		# cyclic_signal_append!(signal_strength, cycle_n, registered_value)
		cycle_n += 1
		cyclic_signal_append!(signal_strength, cycle_n, registered_value)
		registered_value += parse(Int, command_args[2])

	end

end

println(signal_strength)
println("part 1: $(sum(signal_strength))")


##################
##### PART 2 #####
##################
solution::Int = 0

cycle_n::Int = 0
sprite_position::Int = 2 # When you have arrays starting at 1, some things are messed up
CRT = Array{Char, 2}(undef,6,40)

# println(CRT)

println(CRT[1])

function crt_screen_pixel!(screen, sprite_position::Int, cycle_n::Int)
	println(floor(Int, (cycle_n-1)/40 + 1), " ", (cycle_n-1) % 40 + 1)
	
	if ((cycle_n-1) % 40 + 1) == sprite_position - 1 ||
	   ((cycle_n-1) % 40 + 1) == sprite_position     ||
	   ((cycle_n-1) % 40 + 1) == sprite_position + 1
		screen[floor(Int, (cycle_n-1)/40 + 1), (cycle_n-1) % 40 + 1] = '#'
	else
		screen[floor(Int, (cycle_n-1)/40 + 1), (cycle_n-1) % 40 + 1] = '.'
	end
end

for command::String = eachsplit(raw_cont, "\n")
	global cycle_n, sprite_position, CRT
	command_args = split(command, " ")

	cycle_n += 1
	crt_screen_pixel!(CRT, sprite_position, cycle_n)
	# cyclic_signal_append!(signal_strength, cycle_n, registered_value)

	# if command_args[1] == "noop"
	# 	# println(command_args)
	# 	cyclic_signal_append!(signal_strength, cycle_n, registered_value)
	# end
	if command_args[1] == "addx"
		# cyclic_signal_append!(signal_strength, cycle_n, registered_value)
		cycle_n += 1
		#cyclic_signal_append!(signal_strength, cycle_n, registered_value)
		crt_screen_pixel!(CRT, sprite_position, cycle_n)
		sprite_position += parse(Int, command_args[2])

	end
end

using DelimitedFiles; 
open("CRT.txt", "w") do io
    writedlm(io, CRT, '|')
end

# println("part 2: $solution")
