#!/bin/bash

# The Shebang initialization 

# Outputs prompt and waits for user input, then stores input variable.
read -p echo "Please enter your name:"

# Outputs prompt asking for module name, waits for input and stores in variable.
read -p "Please enter the name of the module you require:" module 

# Gets systems date and stores it in a variable
today=$(date)

# Gives a nice output table for the entered and logged variables

echo "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
echo "Name: $name"
echo "Module: $module"
echo "Date: $today"
echo "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS" 
