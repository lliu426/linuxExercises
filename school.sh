#!/bin/bash

cat Property_Tax_Roll.csv | \
grep "MADISON SCHOOLS" | \
cut -d ',' -f7 | \
tail -n +2 | \
{
    sum=0
    count=0
    while read value; do
        sum=$((sum + value))
        count=$((count + 1))
    done
    echo "Sum: $sum"
    echo "Average: $((sum / count))"
}
