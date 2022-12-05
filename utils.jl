module Fileio
    export read_txt, is_number

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
end