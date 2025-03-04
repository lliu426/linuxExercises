#!/bin/bash
if [ $# -ne 2 ]; then
    echo "usage: ./mean.sh <column> [file.csv]" >&2
    exit 1
fi
COLUMN=$1
if [ $# -eq 2 ]; then
    input=$2
    if [ ! -f "$input" ]; then
        echo "Error: File not found" >&2
        exit 1
    fi
else
    input="/dev/stdin"
fi

{
	tail -n +2 | cut -d',' -f"$column"
} < "$input" | {
	sum=0
	count=0
	while read value; do
		sum=$(echo "$sum + $value" | bc)
		count=$((count+1))
	done

	if [ $count -gt 0 ]; then
		mean = $(echo "$sum / $count" | bc)
		echo $mean
	fi
}
#!/bin/bash

# Check if at least one argument is provided
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "usage: ./mean.sh <column> [file.csv]" >&2
    exit 1
fi

COLUMN=$1

# Validate COLUMN is a positive integer
if ! [[ "$COLUMN" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Column must be a positive integer." >&2
    exit 1
fi

# If a file is provided, use it, otherwise read from stdin
if [ $# -eq 2 ]; then
    input=$2
    if [ ! -f "$input" ]; then
        echo "Error: File not found" >&2
        exit 1
    fi
else
    input="/dev/stdin"
fi

# Extract the required column and compute mean
{
    tail -n +2 "$input" | cut -d',' -f"$COLUMN"
} | {
    sum=0
    count=0
    while read -r value; do
        # Ensure value is a valid number (ignoring empty lines)
        if [[ -n "$value" && "$value" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            sum=$(echo "$sum + $value" | bc)
            count=$((count+1))
        fi
    done

    if [ $count -gt 0 ]; then
        mean=$(echo "scale=2; $sum / $count" | bc)
        echo "$mean"
    else
        echo "Error: No valid numeric data in column $COLUMN" >&2
        exit 1
    fi
}
