#!/bin/csh -f

# Wei Tang, July 9, 2018

# unzip a stack of Sentinel-1 data sets, just extract the vv polarization images
# for interferometry.

if ($#argv != 1) then
    echo ""
    echo "Usage: unzip_sentinel-1.csh Sentinel-1/zipfile/path "
    echo ""
    echo "Example: unzip_sentinel-1.csh /misc/sar1/Western_Germany/Path15_Frame164"
    echo ""
    echo "         Place the Sentinel-1A/B data (S1A_/S1B_******.zip) in a directory"
    echo "         enter to the directory where you want to unzip the data then run this command"
    echo "         This script can unzip both Sentinel-1A and Sentinel-1B data"
    echo ""
    echo ""
    exit 1
  endif
  

# set the data and target directory
set datadir = $1
echo $datadir
set CWD = `pwd`
ls ${datadir}/*.zip > zipfile.list

#set CWD = "/misc/sar1/Western_Germany_RAW/PATH15_FRAME164"

echo
echo "### Unzip Sentinel-1 zipfles START. ###"
echo

foreach zipfile (`cat zipfile.list`)
  set bname = `basename $zipfile`
  set name = `echo $bname | cut -c 1-3`
  set folder=`echo $bname | awk -F . '{print $1}'`
  set foldername=$folder.SAFE
  # skip to unzip files if already exist
  if (-f $zipfile && ! -d $foldername) then
    #set filename = `echo $bname | awk -F '.' '{print $1}'`
    #set direcname=$filename".SAFE"
    unzip -l $zipfile > zip_content
    # unzip support files
    cat zip_content | grep /support/ | awk '{print $4}' > support.list
    foreach sfile (`cat support.list`)
      unzip $zipfile $sfile -d $CWD
    end

    echo "### unzip support finished. ###"

    # unzip measurement file, only VV polarization
    if ($name == "S1A") then
      set iw1_vv = `cat zip_content | grep /measurement/ | grep s1a-iw1-slc-vv | awk '{print $4}'`
      unzip $zipfile $iw1_vv -d $CWD
      set iw2_vv = `cat zip_content | grep /measurement/ | grep s1a-iw2-slc-vv | awk '{print $4}'`
      unzip $zipfile $iw2_vv -d $CWD
      set iw3_vv = `cat zip_content | grep /measurement/ | grep s1a-iw3-slc-vv | awk '{print $4}'`
      unzip $zipfile $iw3_vv -d $CWD
    
    else if ($name == "S1B") then
      set iw1_vv = `cat zip_content | grep /measurement/ | grep s1b-iw1-slc-vv | awk '{print $4}'`
      unzip $zipfile $iw1_vv -d $CWD
      set iw2_vv = `cat zip_content | grep /measurement/ | grep s1b-iw2-slc-vv | awk '{print $4}'`
      unzip $zipfile $iw2_vv -d $CWD
      set iw3_vv = `cat zip_content | grep /measurement/ | grep s1b-iw3-slc-vv | awk '{print $4}'`
      unzip $zipfile $iw3_vv -d $CWD
    endif
    
    echo
    echo "### unzip measurement finished. ###"
    echo
    # unzip the annotation files
    cat zip_content | grep /annotation/ | awk '{print $4}' > annotation.list
    foreach afile (`cat annotation.list`)
      unzip $zipfile $afile -d $CWD
    end
    echo
    echo "### unzip annotation finished. ###"
    echo
    
    set safefile = `cat zip_content | grep manifest.safe | awk '{print $4}'`
    unzip $zipfile $safefile -d $CWD
    
    # unzip the preview files
    cat zip_content | grep /preview/ | awk '{print $4}' > preview.list
    foreach pfile (`cat preview.list`)
      unzip $zipfile $pfile -d $CWD
    end

  endif 
end

#rm -f zipfile.list
rm -f zip_content
rm -f support.list
rm -f  annotation.list
rm -f preview.list

echo
echo "### Unzip Sentinel-1 zipfles END. ###"
echo
