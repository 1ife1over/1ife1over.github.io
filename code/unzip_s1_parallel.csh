#!/bin/csh -f

# Huayan Dai,2021.11.12

# unzip a stack of Sentinel-1 data sets, just extract the vv polarization images
# for interferometry.

if ($#argv != 2)then
    echo ""
    echo "Usage: unzip_s1_parallel.csh Sentinel-1/zipfile/path  ncores"
    echo ""
    echo "Example: unzip_s1_parallel.csh /misc/sar1/Western_Germany/Path15_Frame164 10"
    echo ""
    echo "         Place the Sentinel-1A/B data (S1A_/S1B_******.zip) in a directory"
    echo "         enter to the directory where you want to unzip the data then run this command"
    echo "         This script can unzip both Sentinel-1A and Sentinel-1B data"
    echo "         "
    echo ""
    exit 1
endif
  

# set the data and target directory
set datadir = $1
set ncores = $2
ls ${datadir}/*.zip > zipfile.list
set num = 1
foreach file (`cat zipfile.list`)
  echo "./unzip_s1.csh $file $num > log.txt" >> unzip_batch.cmd
  @ num = $num + 1
end

parallel --jobs $ncores < unzip_batch.cmd

#rm -f zipfile.list
rm -f log.txt

echo
echo "### Unzip Sentinel-1 zipfles END. ###"