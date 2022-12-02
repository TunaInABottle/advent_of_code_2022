function sum_string(string)
    values = split(string, "\n")

    # convert to int
    int_vals = map(x -> parse(Int, x), values)

    # show vector
    #println(int_vals)

    return sum(int_vals)
end

function last_n(vector, n)
    return vector[length(vector)-n+1:length(vector)]
end

# opening a file in read_mode
f = open("data.txt", "r")
# read entire file into a string
s = read(f, String)	
close(f)


pt1 = split(s, r"\n\n")

sum_vect = map( x -> sum_string(x), pt1)

#println(sum_vect)

println( maximum(sum_vect) )

println(sum(last_n(sort(sum_vect), 3)))