#! /bin/bash
# Script for extracting time-domain data from HomeFries performance tests

declare -r IN_FILE="$1"

# Write header
echo 'test, algo, case 1, case 2, case 3, case 4, case 5, case 6, case 7, case 8, case 9, case 10'

cat "$IN_FILE" | grep 'Test Case.*values' | sed -E 's:.*-\[([A-Za-z]+)HashPerformanceTests ([^]]+).*values\: \[([^]]+).*:\1, \2, \3:'
