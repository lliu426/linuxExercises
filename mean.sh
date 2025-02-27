#!bin/bash
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
