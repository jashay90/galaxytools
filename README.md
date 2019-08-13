# galaxytools
Each folder contains a script, a corresponding Galaxy tool wrapper, and test data.
## countandcluster
Takes a bam alignment file and a tab-delimited file defining the cluster identity of each reference sequence as input. Produces two output files -- a file with counts and proportion covered for each reference sequence, and a file with the maximum count and proportion covered within each cluster.
## filterinfo
Takes two fastq files, counts the number of lines/sequences per file, and reports the fraction of reads in one file vs. the other. Can also double the read count for both files with the paired option.
