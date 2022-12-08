include("../utils.jl")
using .Fileio
using DelimitedFiles

raw_cont::String = read_txt(ARGS[1] * ".txt")

##################
##### PART 1 #####
##################

function is_visible_top(forest, row::Int, col::Int)::Bool
	tree = getindex(forest,row,col)
	for top_idx in 1:(row-1)
		if getindex(forest,top_idx,col) ≥ tree
			return false
		end
	end
	return true
end

function is_visible_bottom(forest, row::Int, col::Int)::Bool
	tree = getindex(forest,row,col)
	for bottom_idx in (row+1):size(forest)[1]
		if getindex(forest,bottom_idx,col) ≥ tree
			return false
		end
	end
	return true
end

function is_visible_right(forest, row::Int, col::Int)::Bool
	tree = getindex(forest,row,col)
	for right_idx in (col+1):size(forest)[2]
		if getindex(forest,row,right_idx) ≥ tree
			return false
		end
	end
	return true
end

function is_visible_left(forest, row::Int, col::Int)::Bool
	tree = getindex(forest,row,col)
	for left_idx in 1:(col-1)
		if getindex(forest,row,left_idx) ≥ tree
			return false
		end
	end
	return true
end

function is_visible(forest, v_idx::Int, h_idx::Int)::Bool
	# tree is on an edge
	if v_idx == 1 || v_idx == size(forest)[1] ||
	   h_idx == 1 || h_idx == size(forest)[2]
		return true
	end
	if is_visible_top(forest,v_idx,h_idx) ||
	   is_visible_bottom(forest,v_idx,h_idx) ||
	   is_visible_right(forest,v_idx,h_idx) ||
	   is_visible_left(forest,v_idx,h_idx)
		return true
	end
	return false
end


solution::Int = 0

line_length::Int = length(split(raw_cont, "\n")[1])
forest = Array{Int}(undef,line_length,0)

# reading from file
for horizontal_trees::String = eachsplit(raw_cont, "\n")
	horizontal_trees_array::Array{Int} = []

	for tree::Char in horizontal_trees
		push!(horizontal_trees_array, parse(Int,tree))
	end

	global forest = hcat(forest, horizontal_trees_array)
end

# TODO find a way to avoid this
forest = forest'

# pretty matrix print
# writedlm(stdout, forest)

# checking if tree is hidden
for v_idx in 1:size(forest)[1]
	for h_idx in 1:size(forest)[2]
		if is_visible(forest,v_idx,h_idx)
			global solution += 1
		end
	end
end

println("part 1: $solution")


##################
##### PART 2 #####
##################
solution::Int = 0

function top_scenic_score(forest, row::Int, col::Int)::Int
	this_tree::Int = getindex(forest,row,col)
	score::Int = 0
	for top_idx in (row-1):-1:1
		score += 1
		if getindex(forest,top_idx,col) ≥ this_tree
			break
		end
	end
	return score
end

function bottom_scenic_score(forest, row::Int, col::Int)::Int
	this_tree::Int = getindex(forest,row,col)
	score::Int = 0
	for bottom_idx in (row+1):size(forest)[1]
		score += 1
		if getindex(forest,bottom_idx,col) ≥ this_tree
			break
		end
	end
	return score
end

function right_scenic_score(forest, row::Int, col::Int)::Int
	this_tree::Int = getindex(forest,row,col)
	score::Int = 0
	for right_idx in (col+1):size(forest)[2]
		score += 1
		if getindex(forest,row,right_idx) ≥ this_tree
			break
		end
	end
	return score
end

function left_scenic_score(forest, row::Int, col::Int)::Int
	this_tree::Int = getindex(forest,row,col)
	score::Int = 0
	for left_idx in (col-1):-1:1
		score += 1
		if getindex(forest,row,left_idx) ≥ this_tree
			break
		end
	end
	return score
end

function scenic_score(forest, row::Int, col::Int)::Int
	top_score::Int = top_scenic_score(forest,row,col)
	bottom_score::Int = bottom_scenic_score(forest,row,col)
	right_score::Int = right_scenic_score(forest,row,col)
	left_score::Int = left_scenic_score(forest,row,col)
	return top_score * bottom_score * right_score * left_score
end


for v_idx in 1:size(forest)[1]
	for h_idx in 1:size(forest)[2]
		if is_visible(forest,v_idx,h_idx)
			global solution = maximum([solution, scenic_score(forest,v_idx,h_idx)])
		end
	end
end

println("part 2: $solution")
