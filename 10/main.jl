include("../utils.jl")
using .Fileio

raw_cont::String = read_txt(ARGS[1] * ".txt")


function cyclic_signal_append!(signal_strength, cycle_n, cycle_value)
	cycle_sampling = [20, 60, 100, 140, 180, 220]

	if indexin(cycle_n, cycle_sampling) .!= nothing
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

	# "noop" is ignored
	if command_args[1] == "addx"
		cycle_n += 1
		cyclic_signal_append!(signal_strength, cycle_n, registered_value)
		registered_value += parse(Int, command_args[2])

	end

end

println("part 1: $(sum(signal_strength))")


##################
##### PART 2 #####
##################
solution::Int = 0

cycle_n::Int = 0
sprite_position::Int = 2 # When you have arrays starting at 1, some things are messed up
CRT = Array{Char, 2}(undef,6,40)


function crt_screen_pixel!(screen, sprite_position::Int, cycle_n::Int)
	
	if ((cycle_n-1) % 40 + 1) == sprite_position - 1 ||
	   ((cycle_n-1) % 40 + 1) == sprite_position     ||
	   ((cycle_n-1) % 40 + 1) == sprite_position + 1
		screen[floor(Int, (cycle_n-1)/40 + 1), (cycle_n-1) % 40 + 1] = '#'
	else
		screen[floor(Int, (cycle_n-1)/40 + 1), (cycle_n-1) % 40 + 1] = ' '
	end
end

for command::String = eachsplit(raw_cont, "\n")
	global cycle_n, sprite_position, CRT
	command_args = split(command, " ")

	cycle_n += 1
	crt_screen_pixel!(CRT, sprite_position, cycle_n)

	if command_args[1] == "addx"
		cycle_n += 1
		crt_screen_pixel!(CRT, sprite_position, cycle_n)
		sprite_position += parse(Int, command_args[2])

	end
end

# old version
# using DelimitedFiles; 
# open("CRT.txt", "w") do io
#     writedlm(io, CRT, '|')
# end

println("part 2:")
for row in eachrow(CRT)
	for i in 1:length(row)
		print(row[i])
	end
	println()
end
