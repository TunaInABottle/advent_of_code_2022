#!/bin/bash

# @TODO check if string is only made by numbers, do I really want to do that?

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

if [ ! ${#1} -eq 2 ]
  then
    echo "Write a string of length two"
    exit 1
fi

#rm -rf $1 #used for debugging

mkdir $1
cd $1
touch main.jl
touch data.txt
touch example.txt

sec_part() {
  local sec_n=${1:?Must provide an argument}

  line_iter="solution = 0\n\nfor VAR_NAME = eachsplit(raw_cont, \"\\\\n\")\n\t#@TODO exercise\nend\n\n"
  section="\n\n##################\n##### PART ${sec_n} #####\n##################\n${line_iter}println(\"part ${sec_n}: \$score\")"
#   return section
  echo -e $section
}

# preparing the .jl file with code that will surely be written
echo -e "include(\"../utils.jl\")\nusing .Fileio\n\nraw_cont = read_txt(ARGS[1] * \".txt\")" >> main.jl
sec_part 1 >> main.jl
sec_part 2 >> main.jl