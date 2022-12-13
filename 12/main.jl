include("../utils.jl")
using .Fileio

raw_cont::String = read_txt(ARGS[1] * ".txt")

struct Point
	x::Int
	y::Int
	z::Int
	startplain::Bool
	Point(x::Int, y::Int, z::Int) = new(x, y, z, true)
	Point(x::Int, y::Int, z::Int, startplain::Bool) = new(x, y, z, startplain)
end

function parse_char_height(char::String)::Int
	if char == "."
		return 0
	elseif char == "#"
		return 1
	else
		return -1
	end
end

function move!(pos_queue::Array{Point}, geo_map::Array{Int,2}, path_map::Array{Int,2}, end_pos::Array{Int, 1}, hikemode::Bool=false)::Int
	# END::Int = -28
	MAX_HEIGHT = 999


	forced_break::Int = 1000000
	while forced_break > 0

		pos = popfirst!(pos_queue)
		# this is the arrival point
		if pos.x == end_pos[1] && pos.y == end_pos[2]
			return pos.z
		end
		if allowed_right(pos, geo_map) && path_map[pos.x, pos.y+1] == MAX_HEIGHT
			if hikemode && pos.startplain
				if geo_map[pos.x, pos.y+1] > 0
					# hike is beginning
					push!(pos_queue, Point(pos.x, pos.y+1, pos.z+1, false))
					path_map[pos.x, pos.y+1] = pos.z + 1
				else #still on plane
					pushfirst!(pos_queue, Point(pos.x, pos.y+1, pos.z, true))
					path_map[pos.x, pos.y+1] = pos.z
				end
			end
			push!(pos_queue, Point(pos.x, pos.y+1, pos.z+1))
			path_map[pos.x, pos.y+1] = pos.z + 1
		end
		if allowed_left(pos, geo_map) && path_map[pos.x, pos.y-1] == MAX_HEIGHT
			if hikemode && pos.startplain
				if geo_map[pos.x, pos.y-1] > 0
					# hike is beginning
					push!(pos_queue, Point(pos.x, pos.y-1, pos.z+1, false))
					path_map[pos.x, pos.y-1] = pos.z + 1
				else #still on plane
					pushfirst!(pos_queue, Point(pos.x, pos.y-1, pos.z, true))
					path_map[pos.x, pos.y-1] = pos.z
				end
			end
			push!(pos_queue, Point(pos.x, pos.y-1, pos.z+1))
			path_map[pos.x, pos.y-1] = pos.z + 1
		end
		if allowed_top(pos, geo_map) && path_map[pos.x-1, pos.y] == MAX_HEIGHT
			if hikemode && pos.startplain
				if geo_map[pos.x-1, pos.y] > 0
					# hike is beginning
					push!(pos_queue, Point(pos.x-1, pos.y, pos.z+1, false))
					path_map[pos.x-1, pos.y] = pos.z + 1
				else #still on plane
					pushfirst!(pos_queue, Point(pos.x-1, pos.y, pos.z, true))
					path_map[pos.x-1, pos.y] = pos.z
				end
			end
			push!(pos_queue, Point(pos.x-1, pos.y, pos.z+1))
			path_map[pos.x-1, pos.y] = pos.z + 1
		end
		if allowed_bottom(pos, geo_map) && path_map[pos.x+1, pos.y] == MAX_HEIGHT
			if hikemode && pos.startplain
				if geo_map[pos.x+1, pos.y] > 0
					# hike is beginning
					push!(pos_queue, Point(pos.x+1, pos.y, pos.z+1, false))
					path_map[pos.x+1, pos.y] = pos.z + 1
				else #still on plane
					pushfirst!(pos_queue, Point(pos.x+1, pos.y, pos.z, true))
					path_map[pos.x+1, pos.y] = pos.z
				end
			end
			push!(pos_queue, Point(pos.x+1, pos.y, pos.z+1))
			path_map[pos.x+1, pos.y] = pos.z + 1
		end
		forced_break -= 1
		# println(pos_queue)
		# display(path_map)
	end

	throw("forced break")


	return 1
end

function allowed_right(pos::Point, geo_map::Array{Int,2})::Bool
	# check that right is within dimension
	if pos.y+1 > size(geo_map)[2]
		return false
	end

	# check if height is accessible
	if geo_map[pos.x, pos.y+1] - geo_map[pos.x, pos.y]  > 1
		return false
	end
	return true
end

function allowed_left(pos::Point, geo_map::Array{Int,2})::Bool
	# check that left is within dimension
	if pos.y-1 < 1
		return false
	end

	# check if height is accessible
	if geo_map[pos.x, pos.y-1] - geo_map[pos.x, pos.y]  > 1
		return false
	end
	return true
end

function allowed_top(pos::Point, geo_map::Array{Int,2})::Bool
	# check that top is within dimension
	if pos.x-1 < 1
		return false
	end

	# check if height is accessible
	if geo_map[pos.x-1, pos.y] - geo_map[pos.x, pos.y]  > 1
		return false
	end
	return true
end

function allowed_bottom(pos::Point, geo_map::Array{Int,2})::Bool
	# check that right is within dimension
	if pos.x+1 > size(geo_map)[1]
		return false
	end

	# check if height is accessible
	if geo_map[pos.x+1, pos.y] - geo_map[pos.x, pos.y]  > 1
		return false
	end
	return true
end

##################
##### PART 1 #####
##################

solution::Int = 0
line_read = split(raw_cont, "\n")
n_col = length(line_read[1])
n_row = length(line_read)
start_pos::Array{Int,1} = []
end_pos::Array{Int,1} = []

geo_map = Array{Int}(undef, n_row, n_col)

row_idx::Int = 0

for line_heights::String = eachsplit(raw_cont, "\n")
	global row_idx += 1
	global geo_map, start_pos, end_pos

	for col_idx::Int = 1:length(line_heights)
		geo_map[row_idx, col_idx] = Int(line_heights[col_idx]) - 97

		# get starting and ending positions
		if line_heights[col_idx] == 'S'
			push!(start_pos, row_idx, col_idx)
			geo_map[row_idx, col_idx] = 0
		elseif line_heights[col_idx] == 'E'
			geo_map[row_idx, col_idx] = Int('z') - 97
			push!(end_pos, row_idx, col_idx)
		end
	end
end

# display(geo_map)

path_map = zeros(Int, n_row, n_col)
fill!(path_map, 999)

current_pos::Array{Point} = [Point(start_pos[1], start_pos[2], 0)]
# println(end_pos)

solution = move!(current_pos, geo_map, path_map, end_pos)
	

# display(path_map)
println("part 1: $solution")

##################
##### PART 2 #####
##################
solution::Int = 0
path_map = zeros(Int, n_row, n_col)
fill!(path_map, 999)

display(geo_map)

current_pos = [Point(start_pos[1], start_pos[2], 0)]
solution = move!(current_pos, geo_map, path_map, end_pos, true)

println("part 2: $solution")
