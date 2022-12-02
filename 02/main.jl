include("../utils.jl")
using .Fileio

# A Y rock - paper
# B X paper - rock
# C Z scissor - scissor

# X rock
# Y paper
# Z scissor

play_points = Dict("A" => Dict("X" => 3, "Y" => 6, "Z" => 0),
                   "B" => Dict("X" => 0, "Y" => 3, "Z" => 6),
                   "C" => Dict("X" => 6, "Y" => 0, "Z" => 3))
tool_points = Dict("X" => 1, "Y" => 2, "Z" => 3)


raw_cont = read_txt("data.txt")

cum_score = 0

for game = eachsplit(raw_cont, "\n")
    play = split(game, " ")
    global cum_score += play_points[play[1]][play[2]] + tool_points[play[2]]
end

println("part 1: $cum_score")

# part 2
# technically not needed, improves readibility
# 0 lose, 3 draw, 6 win
strategy = Dict("X" => 0, "Y" => 3, "Z" => 6) 
response = Dict(0 => Dict("A" => "Z", "B" => "X", "C" => "Y"),
                3 => Dict("A" => "X", "B" => "Y", "C" => "Z"),
                6  => Dict("A" => "Y", "B" => "Z", "C" => "X"))

cum_score = 0

for game = eachsplit(raw_cont, "\n")
    play = split(game, " ")
    their_tool = play[1]
    my_outcome = strategy[play[2]]
    my_tool = tool_points[response[my_outcome][their_tool]]
    global cum_score += my_outcome + my_tool
end

println("part 2: $cum_score")