include("../utils.jl")
using .Fileio

raw_cont::String = read_txt(ARGS[1] * ".txt")

struct point
    x::Int
    y::Int
end

function Base.:(==)(a::point, b::point)
    return a.x == b.x && a.y == b.y
end

function touch(a::point, b::point)
    return a.x == b.x && a.y == b.y     || #same_spot
		   a.x == b.x && a.y == (b.y+1) || #top
		   a.x == b.x && a.y == (b.y-1) || #bottom
		   a.x == (b.x+1) && a.y == b.y || #right
		   a.x == (b.x-1) && a.y == b.y || #left
           (a.x+1) == b.x && (a.y+1) == b.y || #top-right diagonal
           (a.x-1) == b.x && (a.y-1) == b.y || #bottom-left diagonal
           (a.x+1) == b.x && (a.y-1) == b.y || #top-left diagonal
           (a.x-1) == b.x && (a.y+1) == b.y    #bottom-right diagonal
end

function close_gap(head::point, tail::point, old_head::point)   
	if !touch(head, tail)
		return point(old_head.x, old_head.y)
	else
		return point(tail.x, tail.y)
	end
end

function bounded_move(direction::String, head::point, tail::point)
    old_head = head
    if direction == "U"
        new_head = point(head.x, head.y + 1)
    elseif direction == "D"
        new_head = point(head.x, head.y - 1)
    elseif direction == "R"
        new_head = point(head.x + 1, head.y)
    elseif direction == "L"
        new_head = point(head.x - 1, head.y)
    end
	new_tail = close_gap(new_head, tail, old_head)
    return new_head, new_tail
end

##################
##### PART 1 #####
##################
solution::Int = 0

head::point = point(0, 0)
tail::point = point(0, 0)
history::Array{point} = []

for steps::String = eachsplit(raw_cont, "\n")
	instruction = split(steps, " ")
	global history, head, tail
	direction::String = instruction[1]

	for i in 1:parse(Int, instruction[2])
		head, tail = bounded_move(direction, head, tail)
		if !(tail in history)
			push!(history, tail)
		end
	end
end

solution = length(history)

println("part 1: $solution")
