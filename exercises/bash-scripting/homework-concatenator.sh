#!/bin/bash

# Asks for string and stores it in a variable
read -p "Enter a string value:" string1

# Asks for another string and stores it in a variable
read -p "Enter another string value value:" string2

# Concatenaded/summed value

concatenated="$string1$string2"

# Creates a new variable which is the value of characters in the concatenated variable

length=${#concatenated}

# Displays the results in a nice looking table

echo "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
echo "First string: $string1"
echo "Second string: $string2"
echo "Concatenated result: $concatenated"
echo "Length of concatenated string: $length"
echo "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
