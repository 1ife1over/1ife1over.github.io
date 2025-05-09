#!/bin/csh -f
if ($#argv != 2) then
    echo ""
    echo "Usage: unzip_s1.csh Sentinel-1/zipfile/path/file"
    echo ""
    echo "Example: unzip_s1.csh **/**/zipfile num"
    echo ""
    echo "         Place the Sentinel-1A/B data (S1A_/S1B_******.zip) in a directory"
    echo "         enter to the directory where you want to unzip the data then run this command"
    echo "         This script can unzip both Sentinel-1A and Sentinel-1B data"
    echo "         num is a logo to distinguish between different zipfiles"
    echo ""
    exit 1
endif
set zipfile = $1
set logo = $2
set CWD = `pwd`

set bname = `basename $zipfile`
set name = `echo $bname | cut -c 1-3`
set folder=`echo $bname | awk -F . '{print $1}'`
set foldername=$folder.SAFE

# skip to unzip files if already exist
if (-f $zipfile && ! -d $foldername) then
#set filename = `echo $bname | awk -F '.' '{print $1}'`
#set direcname=$filename".SAFE"
unzip -l $zipfile > zip_content$logo
# unzip support files
cat zip_content$logo | grep /support/ | awk '{print $4}' > support$logo.list
foreach sfile (`cat support$logo.list`)
  unzip $zipfile $sfile -d $CWD
end

echo "### unzip support finished. ###"

# unzip measurement file, only VV polarization
if ($name == "S1A") then
  set iw1_vv = `cat zip_content$logo | grep /measurement/ | grep s1a-iw1-slc-vv | awk '{print $4}'`
  unzip $zipfile $iw1_vv -d $CWD
  set iw2_vv = `cat zip_content$logo | grep /measurement/ | grep s1a-iw2-slc-vv | awk '{print $4}'`
  unzip $zipfile $iw2_vv -d $CWD
  set iw3_vv = `cat zip_content$logo | grep /measurement/ | grep s1a-iw3-slc-vv | awk '{print $4}'`
  unzip $zipfile $iw3_vv -d $CWD

else if ($name == "S1B") then
  set iw1_vv = `cat zip_content$logo | grep /measurement/ | grep s1b-iw1-slc-vv | awk '{print $4}'`
  unzip $zipfile $iw1_vv -d $CWD
  set iw2_vv = `cat zip_content$logo | grep /measurement/ | grep s1b-iw2-slc-vv | awk '{print $4}'`
  unzip $zipfile $iw2_vv -d $CWD
  set iw3_vv = `cat zip_content$logo | grep /measurement/ | grep s1b-iw3-slc-vv | awk '{print $4}'`
  unzip $zipfile $iw3_vv -d $CWD
endif

echo
echo "### unzip measurement finished. ###"
echo
# unzip the annotation files
cat zip_content$logo | grep /annotation/ | awk '{print $4}' > annotation$logo.list
foreach afile (`cat annotation$logo.list`)
  unzip $zipfile $afile -d $CWD
end
echo
echo "### unzip annotation finished. ###"
echo

set safefile = `cat zip_content$logo | grep manifest.safe | awk '{print $4}'`
unzip $zipfile $safefile -d $CWD

# unzip the preview files
cat zip_content$logo | grep /preview/ | awk '{print $4}' > preview$logo.list
foreach pfile (`cat preview$logo.list`)
  unzip $zipfile $pfile -d $CWD
end

endif 

rm  zip_content$logo support$logo.list annotation$logo.list preview$logo.list