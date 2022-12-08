# Advent of Code 2022
I want to learn a new programming language so I decided to take on the "Advent of Code" challenge of this year with a new programming language: Julia

You can find more on https://adventofcode.com

# Structure
Each folder is a day, e.g. `01` is day 1 where a `main.js` and the dataset(s) `data.txt` and `example.txt` for the day are contained. `utils.jl` contains a set of utility functions that seems that are not be available natively in Julia yet. `new_day.sh` is a bash script that prepares the folder for the day.

# Execution
After installing Julia, open a folder for the day and execute `julia main.jl` . from day 5 it is also necessary to specify the data source (`example` or `data`) as first argument.

# Personal ideas of Julia
* It has LUA vibes, especially for the closing of loop clauses. Honestly I feel this prevents the dispute on where curly brackets should stay;
* It took me a while to figure out variable scoping, interacting with global variables is not easy. From what I read this seems to be a reasoned choice so that it can improve performance;
    * In general, it makes you think twice when you have variables in a different scope;
* Usage of personal modules has to be very explicit. In your module you have to specify which of the functions have to be exported. I feel like it is better approach than Go's capitalise what you want to export;
* I still have not understood how to set up an environment ._.;
* Documentation is good but is not hard to stumble upon pages that are not up-to-date with the current version of Julia;
* Variable typing is not enforced as long as you do not declare the type. This can be seen as better compared to Python's type hinting.
* You can make intervals from `1:n` but not from `n:1`, as the default change step in an interval is `+1`. If you want a reverse interval you have to write `n:-1:1`
* It supports in-code UNICODE mathematical operands such as `≥` and `∈`
