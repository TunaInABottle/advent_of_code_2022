include("../utils.jl")
include("monkey.jl")
using .Fileio
using .Monkeys

raw_cont::String = read_txt(ARGS[1] * ".txt")




##################
##### PART 1 #####
##################
solution::Int = 0
monkey_zoo = Array{Monkey, 1}()

for monkeys::String = eachsplit(raw_cont, "\n\n")
	global monkey_zoo
	monkey::Monkey = Monkey([], ' ', 0, 0, 0, 0, 0)

	for monkeystring::String = eachsplit(monkeys, "\n")
		params = split(monkeystring, ":")
		if params[1] == "  Starting items"
			for item in split(params[2], ", ")
				push!(monkey.inventory, parse(Int, item))
			end
		elseif params[1] == "  Operation"
			args = split(params[2], " ")
			monkey.inspect_op = args[5][1] #takes the first char, just easier...
			if args[6] == "old"
				monkey.inspect_weight = "old"
			else
				monkey.inspect_weight = parse(Int, args[6])
			end
		elseif params[1] == "  Test"
			args = split(params[2], " ", keepempty = false)
			monkey.throw_test = parse(Int, args[3])
		elseif params[1] == "    If true"
			args = split(params[2], " ", keepempty = false)
			monkey.throw_to_true = parse(Int, args[4]) + 1 #arrays in Julia start from 1...
		elseif params[1] == "    If false"
			args = split(params[2], " ", keepempty = false)
			monkey.throw_to_false = parse(Int, args[4]) + 1
		end
	end
	push!(monkey_zoo, monkey)
end

copy_monkey_zoo = deepcopy(monkey_zoo)

for i in 1:20
	throwing_round!(monkey_zoo, true)
end

solution = prod(sort(map(x -> x.inspect_n, monkey_zoo), rev=true)[1:2])
println("part 1: $solution")

##################
##### PART 2 #####
##################
solution::Int = 0

for i in 1:10000
	throwing_round!(copy_monkey_zoo)
end

solution = prod(sort(map(x -> x.inspect_n, copy_monkey_zoo), rev=true)[1:2])
println("part 2: $solution")
