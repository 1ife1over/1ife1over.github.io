#!/bin/csh -f

# Wei Tang, July 10, 2018
if ($#argv == 0) then
    echo ""
    echo "Usage: link_S1_orbits.csh Sentinel-1/orbit/path"
    echo ""
    echo "Example: link_S1_orbits.csh /Volumes/tangwei2/Sentinel-1_orbits"
    echo ""
    echo "         Link the precise orbits of Sentinel-1A/B to the raw folder for interferometry"
    echo "         And create the data.in for next step(preproc_batch_tops.csh)"
    echo "         Place the Sentinel-1A/B orbits (S1A_/S1B_******.EOF) in a directory"
    echo "         Enter to the directory where you want to link the orbit data then run this command"
    echo "         This script can link both Sentinel-1A and Sentinel-1B orbit data"
    echo ""
    echo ""
    exit 1
  endif
  
if ($#argv > 0) then
    set ORBITDIR  = $argv[1]
endif

  
  
rm *.EOF
rm -f tiff.list
rm -f orbit.list
rm -f dates.list


set os = `uname -s`
set CWD = `pwd`
cd $CWD

ls *-iw[123]-slc-vv-*.tiff | awk -F '.' '{print $1}' > tiff.list
cat tiff.list | cut -c 16-23 > dates.list

foreach tiffname (`cat tiff.list`)
  set sname = `echo $tiffname | cut -c 1-3`
  set dd = `echo $tiffname | cut -c 16-23`
  if ( $os == "Linux") then
    set bdate = `date --date="$dd -1 day" +%Y%m%d`
  else if ($os == "Darwin") then
    set bdate = `date -j -v-1d -f %Y%m%d $dd +%Y%m%d`
  else
    echo "unknown OS"
    exit 1
  endif

  if ($sname == "s1a") then
    echo "info: link S1A orbits"
    set orbitfile = `ls ${ORBITDIR}/S1A_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    echo $orbitname >> orbit.list
  else if ($sname == "s1b") then
    echo "info: link S1B orbits"
    set orbitfile = `ls ${ORBITDIR}/S1B_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    echo $orbitname >> orbit.list
  else
    echo "No such file! ${tiff}"
    exit 2
  endif
end

touch data.in
paste -d\:  tiff.list orbit.list > temp1
paste dates.list temp1 | sort -k 1 > temp2
cat temp2 | awk '{print $2}' > data.in
rm -f tiff.list orbit.list temp1 temp2 dates.list
