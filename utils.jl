module Fileio
    export read_txt

    function read_txt(filename)
        # opening a file in read_mode
        f = open(filename, "r")
        # read entire file into a string
        s = read(f, String)	
        close(f)
        return s
    end
end