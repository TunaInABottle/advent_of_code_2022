include("../utils.jl")
using .Fileio

raw_cont::String = read_txt(ARGS[1] * ".txt")
Y_REMAPPING::Int = 0 #490 when example
SYM_EMPTY::String = " "
SYM_ROCK::String = "#"
SYM_SAND::String = "+"

struct Point
	x::Int
	y::Int
	symbol::String
	Point(x::Int, y::Int, symbol::String) = new(x, y, symbol) #assumes that remapping already happened
	Point(x::String, y::String, symbol::String) = new(parse(Int,x), parse(Int,y) - Y_REMAPPING, symbol)
	Point(coord::Vector{SubString{String}}, symbol::String) = new(parse(Int,coord[2])+1, parse(Int,coord[1]) - Y_REMAPPING, symbol)
end

function place_in_cave!(cave::Array{String, 2}, element::Point)
	cave[element.x, element.y] = element.symbol
end

function drop_sand!(cave::Array{String, 2}, sand::Point = Point(1, 500 - Y_REMAPPING, SYM_SAND), problem_n::Int = 1)
	while empty_below(cave, sand)
		sand = Point(sand.x + 1, sand.y, SYM_SAND)

		# out of bounds (problem 1)
		if sand.x > size(cave)[1] && problem_n == 1
			return false
		end
	end	
	# adds side boundaries if needed
	#cave = adjust_cave(cave, sand)

	if empty_left_diag(cave, sand)
		return drop_sand!(cave, Point(sand.x + 1, sand.y - 1, SYM_SAND))
	elseif empty_right_diag(cave, sand)
		return drop_sand!(cave, Point(sand.x + 1, sand.y + 1, SYM_SAND))
	end
	# entirely filled (problem 2)
	if problem_n == 2 && sand.x == 1 && sand.y == 500 - Y_REMAPPING
		return false
	end
	if !empty_left_diag(cave, sand) && !empty_right_diag(cave, sand)
		place_in_cave!(cave, sand)
		return true
		# print_matrix_string(cave)
	end
end

function adjust_cave!(cave::Array{String, 2}, dir::Char)
	if dir == 'L'
		side = Array{String, 2}(undef, size(cave)[1], 1)
		fill!(side, SYM_EMPTY)
		side[size(cave)[1], 1] = SYM_ROCK
		cpy = deepcopy(cave)
		cave = hcat(side, cpy)
		global Y_REMAPPING -= 1
	elseif dir == 'R'
		# add new boundary
		side = Array{String, 2}(undef, size(cave)[1], 1)
		fill!(side, SYM_EMPTY)
		side[size(cave)[1], 1] = SYM_ROCK
		cpy = deepcopy(cave)
		cave = hcat(cpy, side)
	else
		throw("Invalid direction $dir")
	end
	return cave
end

function empty_below(cave::Array{String, 2}, element::Point)
	if element.x + 1 > size(cave)[1] || cave[element.x + 1, element.y] == SYM_EMPTY
		return true
	end
	return false
end

function empty_left_diag(cave::Array{String, 2}, element::Point)
	# print_matrix_string(cave)
	if element.x + 1 > size(cave)[1]
		# free fall
		print("free fall: $(element.y)")
		return true
	end
	if cave[element.x + 1, element.y - 1] == SYM_EMPTY
		return true
	end
	return false
end

function empty_right_diag(cave::Array{String, 2}, element::Point)
	if element.x + 1 > size(cave)[1]
		# free fall
		return true
	end
	if cave[element.x + 1, element.y + 1] == SYM_EMPTY
		return true
	end
	return false
end

##################
##### PART 1 #####
##################

# 180, 10
# 181, 514
# this has been made by brute-forcing
cave = Array{String, 2}(undef, 181, 514-Y_REMAPPING) # TODO dynamic dimension?
fill!(cave, SYM_EMPTY)

for rock_lines::String = eachsplit(raw_cont, "\n")
	rock_edges = split(rock_lines, " -> ")

	rock = Point(split(rock_edges[1], ","), SYM_ROCK)
	place_in_cave!(cave, rock)

	for idx in 2:length(rock_edges)
		# println(idx, " ", rock_edges[idx])
		new_rock = Point(split(rock_edges[idx], ","), SYM_ROCK)

		if (new_rock.x == rock.x)
			for y in min(new_rock.y, rock.y):max(new_rock.y, rock.y)
				place_in_cave!(cave, Point(new_rock.x, y, SYM_ROCK))
			end
		elseif (new_rock.y == rock.y)
			for x in min(new_rock.x, rock.x):max(new_rock.x, rock.x)
				place_in_cave!(cave, Point(x, new_rock.y, SYM_ROCK))
			end
		end
		rock = new_rock
	end
end

# print_matrix_string(cave)

flowing_sand::Bool = true
while flowing_sand
	global flowing_sand = drop_sand!(cave)
	#print_matrix_string(cave)
end

println("part 1: $(count(x -> x == SYM_SAND, cave))")

##################
##### PART 2 #####
##################

floor = Array{String, 2}(undef, 1, 514-Y_REMAPPING) # TODO dynamic dimension?
empty = deepcopy(floor)
fill!(empty, SYM_EMPTY)
fill!(floor, SYM_ROCK)

cave = [cave;empty;floor]



function sand_in_corner(cave, dir::Char)
	if dir == 'L'
		if cave[size(cave)[1]-1, 2] == SYM_SAND
			return true
		end
	elseif dir == 'R'
		if cave[size(cave)[1]-1, size(cave)[2]-1] == SYM_SAND
			return true
		end
	end
	return false
end

flowing_sand::Bool = true
f_stop = 500
while flowing_sand && f_stop > 0
	if sand_in_corner(cave, 'L')
		global cave = adjust_cave!(cave, 'L')
	elseif sand_in_corner(cave, 'R')
		global cave = adjust_cave!(cave, 'R')
	end
	global flowing_sand = drop_sand!(cave, Point(1, 500 - Y_REMAPPING, SYM_SAND), 2)
	# print_matrix_string(cave)
	# global f_stop -= 1
end


println("part 2: $(count(x -> x == SYM_SAND, cave) +1)")
