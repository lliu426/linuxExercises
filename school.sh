#!/bin/bash

cat Property_Tax_Roll.csv | grep "MADISON SCHOOLS" | cut -d ',' -f 7 | tail -n +2 | awk '
    BEGIN { sum = 0; count = 0; }
    {
        sum += $1;
        count++;
    }
    END { print sum / count }
'
