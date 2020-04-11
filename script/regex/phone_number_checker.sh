#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
# Default input file on same dir or can pass in on runtime
INPUT_FILE_PATH="./input.txt"

# Phone number format checker
echo -e "Valid Phone Numbers:"

# Valid Format
# 111-111-1111 OR (111) 111-1111
while IFS= read -r line
do
  if [[ $line =~ (^[0-9]{3}-[0-9]{3}-[0-9]{4}$)|(^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$) ]]; then
    echo -e $line
  fi
done < $INPUT_FILE_PATH