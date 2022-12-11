module Monkeys
export Monkey, throwing_round!

    global common_lcm = 0
    global l_cooldown::Bool

    mutable struct Monkey
        inventory::Array{Int}
        inspect_op::Char
        inspect_weight::Union{Int, String}
        throw_test::Int 
        throw_to_true::Int
        throw_to_false::Int
        inspect_n::Int
    end

    function monkey_lcm(team::Array{Monkey})
        dividents::Array{Int, 1} = Array{Int, 1}()
        for monkey in team
            push!(dividents, monkey.throw_test)
        end
        return lcm(dividents...)
    end

    function worry_level(monkey::Monkey, item::Int)::Int
        # increase inspection counter
        monkey.inspect_n += 1
    
        increasefactor::Int = 0
        if monkey.inspect_weight == "old"
            increasefactor = item
        else
            increasefactor = monkey.inspect_weight
        end
    
        if monkey.inspect_op == '*'
            return item * increasefactor
        elseif monkey.inspect_op == '+'
            return item + increasefactor
        else
            throw("unexpected operation $(monkey.inspect_op)")
        end
    end
    
    function throw_to!(monkey::Monkey, teammates::Array{Monkey}, item::Int)
        # global least_comm_mult
        opt_item_val = item % common_lcm
        if opt_item_val % monkey.throw_test == 0
            push!(teammates[monkey.throw_to_true].inventory, opt_item_val)
        else
            push!(teammates[monkey.throw_to_false].inventory, opt_item_val)
        end
    end
    
    function turn!(monkey::Monkey, teammates::Array{Monkey})
        global cooldown
        for index in 1:length(monkey.inventory)
            # take the item
            item = popfirst!(monkey.inventory)
            # play with item, get bored
            item = worry_level(monkey, item)
            # get reduce worryness (part 1 only)
            if l_cooldown == true
                item = Int(floor(item / 3))
            end
            # throw item
            throw_to!(monkey, teammates, item)	
        end
    end
    
    function throwing_round!(monkeys::Array{Monkey}, cooldown::Bool=false)
        global common_lcm = monkey_lcm(monkeys)
        global l_cooldown = cooldown
        for monkey in monkeys
            turn!(monkey, monkeys)
        end
    end
end