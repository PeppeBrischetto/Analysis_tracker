#!/bin/bash
#
# This script all the binary file of a run in root by mean
# of converter_solaris_tracker.C and merge all the root file in a single root file
# by mean of merger.C
# requires as input the run number and the correct path of the input
# and output directories
#
#  created 25-11-2022  D. Torresi
# 
#  last update:
#

# Definizione variabili
#run number
run=$1

#################################################
# directories
#bindir=~/Analisi/Analysis_tracker/Raw_data/run_$run
bindir=/home/numen/solaris/RAW_data/tracker_and_sic/
caldir=~/Analysis_tracker_v1.0/Cal_data/run_$run
merdir=~/Analysis_tracker_v1.0/Merged_data/run_$run


#################################################
#  Converting binary to root
################################################

# If the output directory does not exist create it
mkdir  $caldir
mkdir  $merdir
echo " binary directory: "$bindir
echo " calib  directory: "$caldir
echo " merged directory: "$merdir

# lopp on the 5 digitizers
#for dig in 22642 22643 22644 22645 22646

cont=1
for dig in 22642 22643 22644 22645 21247
do  
   list="$(ls $bindir/tracker_and_sic_$run\_0$cont\_$dig\_00?.sol)"
   #infile=$bindir/tracker_and_sic_$run\_0$cont\_$dig\_000.sol
   outfile=$caldir/dig_$dig\_cal.root
   cont=$(($cont+1))
   rm $outfile
   for infile in $list; 
       do if [-f "$infile" ]; 
             then root -q -l "converter_solaris_tracker_full.C(\"$infile\",$dig,\"$outfile\")";
          fi;
       done
   
   echo " Input file:  "$infile
   echo " Output file: "$outfile
   # convert data
   #root -q -l "converter_solaris_tracker.C(\"$infile\",$dig,\"$outfile\")"

done

#################################################
# Merging data
#################################################

merfile=$merdir/merged.root

initfile=$caldir/dig_22642_cal.root    # very first file to be merged
file1=a.root			        # first argument of macro
file2=b.root			        # second argument of macro
outfile=c.root				# macro output

cp $initfile $file1

echo "---------"

for dig in 22643 22644 22645 21247
   do
   # fill the $file2 
   cp $caldir/dig_$dig\_cal.root $file2
   echo "file 1: " $file1
   echo "file 2: " $file2

   root -q -l "merger.C(\"$file1\",\"$file2\", \"$outfile\")"
   # make the output the first argument of the next step
   cp $outfile $file1
   
done

# remove unecesary files
rm $file1 $file2
# put the final output in the correct directory
mv $outfile  $merdir/merg_$run.root










