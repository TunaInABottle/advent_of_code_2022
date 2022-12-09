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

function close_gap(head::point, tail::point)
		new_x = tail.x
		new_y = tail.y
		if tail.y > head.y + 1 #tail is above head
			new_y -= 1
			if tail.x > head.x #tail is diagonal top right of head
				new_x -= 1
			elseif tail.x < head.x #tail is diagonal top left of head
				new_x += 1
			end
		elseif tail.y < head.y - 1 #tail is below head
			new_y += 1
			if tail.x > head.x #tail is diagonal bottom right of head
				new_x -= 1
			elseif tail.x < head.x #tail is diagonal bottom left of head
				new_x += 1
			end
		elseif tail.x > head.x + 1 #tail is right of head
			new_x -= 1
			if tail.y > head.y #tail is diagonal bottom right of head
				new_y -= 1
			elseif tail.y < head.y #tail is diagonal top right of head
				new_y += 1
			end
		elseif tail.x < head.x - 1 #tail is left of head
			new_x += 1
			if tail.y > head.y #tail is diagonal bottom left of head
				new_y -= 1
			elseif tail.y < head.y #tail is diagonal top left of head
				new_y += 1
			end
		end
	return point(new_x, new_y)
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
	new_tail = close_gap(new_head, tail)
    return new_head, new_tail
end

##################
##### PART 2 #####
##################

struct rope
	knots::Array{point}
end

function bounded_move(direction::String, rope_var::rope)
	new_rope_arr::Array{point} = []

	head_knot = rope_var.knots[1]
	tail_knot = rope_var.knots[2]
	head_knot, tail_knot = bounded_move(direction, head_knot, tail_knot)
	push!(new_rope_arr, head_knot)
	push!(new_rope_arr, tail_knot)
	for i in 3:length(rope_var.knots)
		new_knot = close_gap(new_rope_arr[i-1], rope_var.knots[i])
		push!(new_rope_arr, new_knot)		
	end
	return rope(new_rope_arr)
end

history = []
# Sad way to have 10 points
rope_obj::rope = rope([point(0, 0), point(0, 0), point(0, 0), point(0, 0),
				   point(0, 0), point(0, 0), point(0, 0),
				   point(0, 0), point(0, 0), point(0, 0)])

for steps::String = eachsplit(raw_cont, "\n")
	instruction = split(steps, " ")
	global history
	global rope_obj
	direction::String = instruction[1]
	for i in 1:parse(Int, instruction[2])
		rope_obj = bounded_move(direction, rope_obj)
		if !(rope_obj.knots[10] in history)
			push!(history, rope_obj.knots[10])
		end
	end
end

println("part 2: $(length(history))")
