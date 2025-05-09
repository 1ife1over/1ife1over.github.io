#!/bin/csh -f

# Wei Tang, July 10, 2018

if ($#argv == 0) then
    echo ""
    echo "Usage: link_S1.csh Sentinel-1/data/path swathnumber"
    echo ""
    echo "Example: link_S1.csh /misc/sar1/Western_Germany/Path15_Frame164 1"
    echo ""
    echo "         Link a stack of Sentinel-1A/B data sets to the raw folder for interferometry"
    echo "         Place the Sentinel-1A/B data (S1A_/S1B_******.SAFE) in a directory"
    echo "         Enter to the directory where you want to link the data then run this command"
    echo "         This script can link both Sentinel-1A and Sentinel-1B data"
    echo ""
    echo ""
    exit 1
  endif
  
if ($#argv > 0) then
    set DATADIR  = $argv[1]
endif

if ($#argv > 1) then
    set subswath = $argv[2]
endif

set CWD = `pwd`
cd $CWD

ls -d $DATADIR/*.SAFE > files.list


foreach sfile (`cat files.list`)
  echo info :$sfile
  # link the xml files in the annotation directory
  ln -s ${sfile}/annotation/s1[ab]-iw$subswath-slc-vv-* .
  ln -s ${sfile}/measurement/s1[ab]-iw$subswath-slc-vv-*.tiff .
  rm -f files.list
end
