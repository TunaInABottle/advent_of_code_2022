include("../utils.jl")
using .Fileio

raw_cont::String = read_txt(ARGS[1] * ".txt")

struct Point
	x::Int
	y::Int
	type::String
	Point(x::Int, y::Int, type::String) = new(x, y, type)
	Point(x::Int, y::Int) = new(x, y, "null")
end

struct Sensor
	coord::Point
	distance::Int
	Sensor(coord::Point, distance::Int) = new(coord, distance)
end

function withinarea(sensor::Sensor, point::Point)::Bool
	return manhattan_distance(sensor.coord, point) <= sensor.distance
end

function manhattan_distance(p1::Point, p2::Point)::Int
	return abs(p1.x - p2.x) + abs(p1.y - p2.y)
end

function see_y_axis(p1::Point, p2::Point, y::Int)::Bool
	if p1.y < p2.y
		return p1.y <= y && y <= p2.y
	elseif p1.y > p2.y
		return p1.y >= y && y >= p2.y
	elseif p1.y == p2.y
		return p1.y == y
	end
end

function cover_y_axis(pt::Point, d::Int, y::Int)::Bool
	return pt.y - d <= y && y <= pt.y + d
end

# returns a boolean of indices for elements that interact with a certain y axis
function y_interactions(sensors::Array{Point, 1}, beacons::Array{Point, 1}, distances::Array{Int, 1}, y_target::Int)::Array{Bool, 1}
	intersect::Array{Bool, 1} = map((x, y) -> see_y_axis(x, y, y_target), sensors, beacons) # TODO unneded?
	covered::Array{Bool, 1} = map((x, y) -> cover_y_axis(x, y, y_target), sensors, distances)
	return map((x, y) -> x || y, intersect, covered)
end

function coverage_in_target(sensor::Point, distance::Int, y_target::Int)::Array{Int, 1}
	Δy = abs(sensor.y - y_target)
	Δx = abs(distance - Δy)
	return [x for x in (sensor.x - Δx):(sensor.x + Δx)]
end

function coverage_in_target(sensor::Point, distance::Int, y_target::Int, min_coord::Int, max_coord::Int)::Array{Int, 1}
	# println("sensor: $(sensor.x), $(sensor.y)")
	# println("distance: $distance")
	Δy = abs(sensor.y - y_target)
	# Δx = distance - Δy
	Δx = abs(distance - Δy) #testing
	# println("Δy: $Δy")
	# println("Δx: $Δx")
	min_interval::Int = maximum([min_coord, (sensor.x - Δx)])
	max_interval::Int = minimum([max_coord, (sensor.x + Δx)])
	# println("min $min_interval,\n max $max_interval")
	# println(min_interval:max_interval)
	# println(min_interval < max_interval)
	return [x for x in min_interval:max_interval]
end


##################
##### PART 1 #####
##################
solution::Int = 0
sensors::Array{Point, 1} = []
beacons::Array{Point, 1} = []
distances::Array{Int, 1} = []


for detections::String = eachsplit(raw_cont, "\n", keepempty=false)
	values = [x.match for x in eachmatch(r"(?<=[x|y]=)-?\d+", detections)]
	sensor = Point(parse(Int, values[1]), parse(Int, values[2]), "sensor")
	beacon = Point(parse(Int, values[3]), parse(Int, values[4]), "beacon")
	
	push!(sensors, sensor)
	push!(beacons, beacon)
	push!(distances, manhattan_distance(sensor, beacon))
end


### Obtaining all cells covered in target y axis
y_target::Int = 0
if ARGS[1] == "example"
	y_target::Int = 10
else
	y_target::Int = 2000000
end

interact_y::Array{Bool, 1} = y_interactions(sensors, beacons, distances, y_target)


x_in_target::Array{Int, 1} = []
for idx in findall(interact_y)
	# PYTHONIC!
	[push!(x_in_target, x) for x in coverage_in_target(sensors[idx], distances[idx], y_target)]
end
x_in_target = unique(x_in_target)

# removing beacons in the coverage area, as those do not count
beacon_in_y::Array{Bool, 1} = map(bcn -> bcn.y == y_target, beacons)
beaconstoremove = unique(beacons[beacon_in_y])

for beacon in beaconstoremove
	deleteat!(x_in_target, findall(x -> x == beacon.x, x_in_target))
end


println("part 1: $(length(x_in_target))")



#######################
##### PART 2 (V2) #####
#######################

sensors_struct::Array{Sensor, 1} = [Sensor(sensors[i], distances[i]) for i in 1:length(sensors)]

min_val::Int = 0 
if ARGS[1] == "example"
	max_val::Int = 20
elseif ARGS[1] == "data"
	max_val::Int = 4000000
end

function within(val::Int, min::Int, max::Int)::Bool
	return val >= min && val <= max
end

function bounded_push!(arr::Array{Point, 1}, val::Point, min::Int, max::Int)::Array{Point, 1}
	if within(val.x, min, max) && within(val.y, min, max)
		push!(arr, val)
	end
	return arr
end

function periphery(sensor::Sensor, min::Int, max::Int)::Array{Point, 1}
	periphery_points::Array{Point, 1} = []
	# starting from top
	curr_x::Int = sensor.coord.x
	curr_y::Int = sensor.coord.y
	x_offset::Int = 0
	y_offset::Int = sensor.distance + 1
	while y_offset >= 0
		# top right diag
		bounded_push!(periphery_points, Point(sensor.coord.y - y_offset, sensor.coord.x + x_offset), min, max)
		# top left diag
		bounded_push!(periphery_points, Point(sensor.coord.y - y_offset, sensor.coord.x - x_offset), min, max)
		# bottom right diag
		bounded_push!(periphery_points, Point(sensor.coord.y + y_offset, sensor.coord.x + x_offset), min, max)
		# bottom left diag
		bounded_push!(periphery_points, Point(sensor.coord.y + y_offset, sensor.coord.x - x_offset), min, max)

		x_offset += 1
		y_offset -= 1
	end
	return unique(periphery_points)
end

function detected(sensors::Array{Sensor, 1}, point::Point)::Bool
	for sensor in sensors
		if withinarea(sensor, point)
			return true
		end
	end
	return false
end

function signal_origin(sensors::Array{Sensor, 1}, min_val::Int, max_val::Int)
	for focus_sensor in sensors
		neightbour = periphery(focus_sensor, min_val, max_val)

		for point in neightbour
			if !detected(sensors, point)
				return point
			end
		end
	end
end

distressbeacon = signal_origin(sensors_struct, min_val, max_val)

println("part 2: $(distressbeacon.x * 4000000 + distressbeacon.y)")



######################
##### PART 2 OLD #####
######################

# Uses a more mathematical approach
# works on example, fails on data
# as it finds no solution

##################

# function scan_row(y::Int, sensors::Array{Sensor, 1}, min::Int, max::Int)
# 	x::Int = min
# 	distressbeacon::Point = Point(0, 0)
# 	println(y)
# 	while x <= max
# 		scanning::Point = Point(x, y)
# 		break_flag::Bool = false
# 		for sensor::Sensor in sensors_struct
# 			if withinarea(sensor, scanning)
# 				print("from $x")
# 				Δx = sensor.distance - abs(sensor.coord.y - scanning.y)
# 				x += Δx * 2 + 1 # cross sensor's area
# 				x -= sensor.distance - manhattan_distance(sensor.coord, scanning) # adjust if in startedwithin area
# 				println(" because of $sensor reaching $x")
# 				break_flag = true
# 				break
# 			end
# 		end
# 		if !break_flag
# 			#found the element
# 			println("found")
# 			return true, scanning			
# 		end
# 	end
# 	return false, distressbeacon
# end

# min_val::Int = 0 
# if ARGS[1] == "example"
# 	max_val::Int = 20
# elseif ARGS[1] == "data"
# 	max_val::Int = 4000000
# else
# 	throw("Invalid argument")
# end

# size_in_y::Array{Int,1} = []

# sensors_struct::Array{Sensor, 1} = [Sensor(sensors[i], distances[i]) for i in 1:length(sensors)]
# # println(sensors_struct)

# distressbeacon::Point = Point(0, 0)

# for y in min_val:max_val 
# 	global distressbeacon
# 	x::Int = 0
# 	found_flag::Bool = false
# 	found_flag, distressbeacon = scan_row(y, sensors_struct, min_val, max_val)
	
# 	if found_flag
# 		break
# 	end
# end
# println(distressbeacon)
# println("part 2: $(distressbeacon.x * 4000000 + distressbeacon.y)")