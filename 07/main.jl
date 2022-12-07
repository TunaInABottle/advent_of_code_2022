include("../utils.jl")
using .Fileio
using JSON

raw_cont::String = read_txt(ARGS[1] * ".txt")


##################
##### PART 1 #####
##################
# modify cwd, dirs
function process_command(cmd_string, cwd::String, dirs::Dict)
	if cmd_string[2] == "cd"
		if cmd_string[3] == ".."
			# exit from directory
			cwd = join( split(cwd, "/")[1:end-1] , "/")
		# go to root
		elseif cmd_string[3] == "/"
			cwd = "/"
		# enter in a directorty
		else
			cwd *= "/" * cmd_string[3]
		end
	elseif cmd_string[2] == "ls"
		# it is fine
	else
		throw("command not found")
	end
	return cwd
end

function dict_go_to(dirs::Dict, path::String)
	curr_directory = dirs
	for keys::String = eachsplit(cwd, "/")
		if keys == ""
			continue
		end
		# create sub directory if non-existent
		if !haskey(curr_directory, keys)
			curr_directory[keys] = Dict()
		end
		curr_directory = curr_directory[keys]
	end
	return curr_directory
end

solution::Int = 0

dirs::Dict{String, Union{Int, Dict}} = Dict()
cwd::String = ""

for line::String = eachsplit(raw_cont, "\n")
	global cwd
	global dirs

	split_line = split(line, " ")
	
	if split_line[1] == "\$"
		# it is a command
		cwd = process_command(split_line, cwd, dirs)
	end
	if occursin(r"[0-9]", split_line[1])
		# it is a File
		curr_directory = dict_go_to(dirs, cwd)
		curr_directory[split_line[2]] = parse(Int, split_line[1])
	end
	# # it is a directory
	# if split_line[1] == "dir"
	# end
end

#### recursive map exploration ####

dir_sizes::Array{Int} = []
function recursive_explore!(dirs::Dict)
	dir_sum::Int = 0
	
	for (key, val) in dirs
		
		if isa(val, Dict)
			recursive_explore!(val)
			dir_sum += dirs[key]["sum"]
		else
			dir_sum += val
		end
	end
	# println("assignment")
	dirs["sum"] = dir_sum
	push!(dir_sizes, dir_sum)
end

# this can probably be better
recursive_explore!(dirs)

println("part 1: $(sum(filter(x -> x < 100000, dir_sizes)))")

##################
##### PART 2 #####
##################

space_left::Int = 70000000 - dirs["sum"]

println("part 2: $(minimum(filter(x -> x > (30000000-space_left), dir_sizes)))")
