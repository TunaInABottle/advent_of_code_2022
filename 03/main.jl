include("../utils.jl")
using .Fileio

raw_cont = read_txt("data.txt")

function assign_score(char)
    ascii_val = Int(char)
    if  ascii_val < 123 && ascii_val > 96
        return ascii_val - 96
    elseif ascii_val < 91 && ascii_val > 64
        return ascii_val - 64 + 26
    end
    error("ERR: not an alphabetic char")
end


score = 0

for rucksack_content = eachsplit(raw_cont, "\n")
    size = length(rucksack_content)
    half = convert(Int64, size/2)

    first_compart = rucksack_content[1:half]
    second_compart = rucksack_content[half+1:size]
    
    match = false

    for first_char in first_compart
        if match == false
            for second_char in second_compart
                if first_char == second_char
                    match = true
                    # println(assign_score(first_char))
                    # println("equal char is $first_char, $(assign_score(first_char))") 
                    global score += assign_score(first_char)
                    break
                end
            end
        end
    end

end


println("part 1: $score")

# part 2
score = 0

function common_between(string_one, string_two)
    matches = []

    for first_char in string_one
        for second_char in string_two
            if first_char == second_char && !(first_char in matches)
                push!(matches, first_char)
            end
        end
    end
    return matches
end

elfs = []

for rucksack_content = eachsplit(raw_cont, "\n")
        global elfs
        global score
        push!(elfs, rucksack_content)
        if length(elfs) == 3
            common_goods = common_between(elfs[1], elfs[2])
            common_goods = common_between(common_goods, elfs[3])
            score += assign_score(common_goods[1])
            elfs = []
        end
    
end

println("part 2: $score")