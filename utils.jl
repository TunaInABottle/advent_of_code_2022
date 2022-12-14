module Fileio
    export read_txt, is_number, print_matrix_string

    function read_txt(filename)
        # opening a file in read_mode
        f = open(filename, "r")
        # read entire file into a string
        s = read(f, String)	
        close(f)
        return s
    end

    function is_number(char)
        ascii_val = Int(char)
        if  ascii_val < 58 && ascii_val > 47
            return true
        end
        return false
    end

    function print_matrix_string(matrix)
        for row in eachrow(matrix)
            for i in 1:length(row)
                print(row[i])
            end
            println()
        end
    end
end