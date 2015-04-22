#! /bin/bash
# Script for extracting collision data from HomeFries performance tests

declare -r IN_FILE="$1"

# Write header
echo 'algo, value'

# Grep input file for rows
cat "$IN_FILE" | grep 'Number of collisions' | sed -E "s:.*Number of collisions using ([a-zA-Z]+)\: ([0-9]+).*:\1, \2:"