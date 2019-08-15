#!/bin/bash
# Julie Shay
# July 30, 2019
# Literally just runs wc on two fastq files, assumes paired reads so it divides wc by two
# to get total number of reads.
# Then outputs number of reads and proportion of first vs. second input


while getopts '1:2:o:ph' flag; do
	case $flag in
		1)
			FULL=$OPTARG
			;;
		2)
			FILTERED=$OPTARG
			;;
		o)
			OUT=$OPTARG
			;;
		p)
			divideby=2
			;;
		h)
			h=1
			;;
	esac
done

if [[ -n "$h" || ! -f $FULL || ! -f $FILTERED ]]; then
	echo "Usage: $0 -1 full.fq -2 filtered.fq -o outfile [-p]"
	echo "Where full.fq contains unfiltered sequences (either R1 or R2)"
	echo "and filtered.fq filtered sequences."
	echo "Use -p to specify that inputs are part of a set of paired reads"
	echo "The script will just print the number of sequences (* 2 with -p option) and the proportion filtered/full"
else
	if [ -z "$divideby" ]; then
		divideby=4
	fi
	# print % reads passing filter to an outfile
	if [ $(file $FILTERED | awk '{print $2}') == "gzip" ]; then
		pass=$(gunzip -c $FILTERED | wc -l | awk '{print $1}')
	else
		pass=$(wc -l $FILTERED | awk '{print $1}')
	fi
	pass=$(expr $pass / $divideby)
	if [ $(file $FULL | awk '{print $2}') == "gzip" ]; then
		total=$(gunzip -c $FULL | wc -l | awk '{print $1}')
	else
		total=$(wc -l $FULL | awk '{print $1}')
	fi
	total=$(expr $total / $divideby)
	prop=$(echo "scale=5; $pass/$total" | bc -l)
	echo -e "Input Reads\tReads Passing Filter\tFraction Reads Passing Filter" > $OUT
	echo -e ${total}"\t"${pass}"\t"$prop >> $OUT
fi
