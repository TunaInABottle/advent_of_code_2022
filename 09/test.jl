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
    # if !touch(new_head, tail)
	# 	new_tail = point(old_head.x, old_head.y)
	# else
	# 	new_tail = point(tail.x, tail.y)
	# end
    return new_head, new_tail
end


############################


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
		new_knot = close_gap(new_rope_arr[i-1], rope_var.knots[i], rope_var.knots[i-1])
		push!(new_rope_arr, new_knot)		
	end
	return rope(new_rope_arr)
end

the_knots = [point(1, 0), point(0, 0), point(0, 0),
point(0, 0), point(0, 0), point(0, 0),
point(0, 0), point(0, 0), point(0, 0)]

rope_obj::rope = rope(the_knots)
println(rope_obj)
println(rope_obj.knots[1])

rope_obj = bounded_move("R", rope_obj)
rope_obj = bounded_move("R", rope_obj)
println(rope_obj)