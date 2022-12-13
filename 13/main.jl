include("../utils.jl")
using .Fileio

raw_cont::String = read_txt(ARGS[1] * ".txt")

function verify_order(a, b)::Union{Bool, Nothing}
	if (a == b)
		return nothing
	elseif (a isa Int && b isa Int)
		if (a == b)
			return nothing
		# both integers
		elseif (a > b)
			return false
		else
			return true
		end
	elseif (a isa Int && !(b isa Int))
		# one vector, one integer case 1
		return verify_order([a], b)
	elseif (!(a isa Int) && b isa Int)
		# one vector, one integer case 2
		return verify_order(a, [b])
	elseif (!(a isa Int) && !(b isa Int))
		# both vectors
		if length(a) == 0 && length(b) != 0
			# packet comes before as it is empty
			return true
		elseif length(b) == 0 && length(a) != 0
			# packet comes after as it is empty
			return false
		else
			# iterate both arrays
			for idx in 1:length(a)
				if (idx > length(b))
					# a comes after as it is longer
					return false
				end
				is_ordered = verify_order(a[idx], b[idx])
				if !isnothing(is_ordered)
					return is_ordered
				end
			end
			if length(a) < length(b)
				# there are still elements in b
				return true
			end
		end
	end
end

function ordered_packets(packets_a::String, packets_b::String)::Bool
	pkt_a = eval(Meta.parse(packets_a))
	pkt_b = eval(Meta.parse(packets_b))

	a_before_b = verify_order(pkt_a, pkt_b)
	if !isnothing(a_before_b)
		return a_before_b
	end
	if length(pkt_a) < length(pkt_b)
		return true
	end

	throw("something went wrong: $pkt_a ||| $pkt_b")
end

##################
##### PART 1 #####
##################
solution::Int = 0
idx::Int = 0

for signals::String = eachsplit(raw_cont, "\n\n")
	global idx += 1
	pairs = split(signals, "\n")
	
	ordered = ordered_packets(String(pairs[1]), String(pairs[2]))
	if ordered
		global solution += idx
	end
end

println("part 1: $solution")

##################
##### PART 2 #####
##################
solution::Int = 0

# sorted_signals = [[[2]], [[6]]]
sorted_signals = ["[[2]]", "[[6]]"]

for new_signal = split(raw_cont, "\n", keepempty=false)
	index::Int = 0
	for s_signal in sorted_signals
		index += 1
		if !ordered_packets(s_signal, String(new_signal))
			insert!(sorted_signals, index, String(new_signal))
			# println(sorted_signals)
			break
		elseif index == length(sorted_signals)
			push!(sorted_signals, String(new_signal))
			break
		end
	end
end

function equal_2(val)::Bool
	return val == "[[2]]"
end

solution = findall( x -> x == "[[6]]", sorted_signals)[1] * findall( x -> x == "[[2]]", sorted_signals)[1]
println("part 2: $solution")
