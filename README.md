# Advent of Code 2022
I want to learn a new programming language so I decided to take on the "Advent of Code" challenge of this year with a new programming language: Julia

You can find more on https://adventofcode.com

# Structure
Each folder is a day, e.g. "01" is day 1 where a "main.js" and the dataset(s) for the day are contained. "utils.jl" contains a set of utility functions that seems that are not be available natively in Julia yet. "new_day.sh" is a bash script that prepares the folder for the day.

# Execution
After installing Julia, open a folder for the day and execute "julia main.jl" . from day 5 it is also necessary to specify the data source ("example" or "data")

# Personal idea of Julia
* It feels like LUA, especially for the closing of loop clauses. Honestly I feel StringVlike this prevents the dispute on where curly brackets should stay;
* It took me a while to figure out variable scoping, interacting with global variables is not easy. From what I read this seems to be a reasoned choice so that it can improve performance;
* Usage of personal files is very cool and explicit, in your module you have to specify which of the functions have to be exported. In this reason I feel like it is better than Go which expect you to capitalize all the elements you want to export;
* I still have not understood how to set up an environment ._.;
* Documentation is good but is not hard to stumble upon pages that are not up-to-date with the current version of Julia;
* Variable typing is not enforced as long as you do not declare the type. This can be seen as better compared to Python's type hinting.
