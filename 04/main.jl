include("../utils.jl")
using .Fileio

raw_cont = read_txt("data.txt")

function pair_string_to_int(string_pair, divider = "-")
    pair = split(string_pair, divider)
    first = parse(Int, pair[1])
    second = parse(Int, pair[2])
    return [first, second]
end

function fully_overlap(first, second)
    first = pair_string_to_int(first)
    second = pair_string_to_int(second)
    if first[1] <= second[1] && first[2] >= second[2]
        return true
    end
    return false
end

#####

score = 0

for pairs = eachsplit(raw_cont, "\n")
    pair = split(pairs, ",")
    if fully_overlap(pair[1], pair[2]) || fully_overlap(pair[2], pair[1])
        global score += 1
    end
end

println("part 1: $score")

# part 2

score = 0

function partial_overlap(first, second)
    first = pair_string_to_int(first)
    second = pair_string_to_int(second)
    if first[1] <= second[1] && first[2] >= second[1]
        return true
    end
    return false
end

for pairs = eachsplit(raw_cont, "\n")
    pair = split(pairs, ",")
    if partial_overlap(pair[1], pair[2]) || partial_overlap(pair[2], pair[1])
        global score += 1
    end
end

println("part 2: $score")