#!/bin/csh -f

# Wei Tang, September 11, 2018
# 
# 
if ($#argv != 2) then
    echo ""
    echo "Usage: create_tops_frame.csh SAFE.list Sentinel-1/orbit/path "
    echo ""
    echo "Example: create_tops_frame.csh SAFE.list Sentinel-1/orbit/path"
    echo ""
    echo "         create Sentinel tops frame using the script create_frame_tops.csh in GMTSAR"
    echo "         by using this script, you can concatenate to a smaller area or to a larger area"
    echo "         and you also can study the area between two TOPS frames"
    echo "         Place the Sentinel-1A/B data (S1A_/S1B_******.SAFE) in a directory"
    echo "         Also place the Sentinel-1A/B orbits (S1A_/S1B_******.EOF) in a directory"
    echo ""
    echo ""
    exit 1
endif

set sf = $1
set ORBITDIR = $2
set os = `uname -s`
rm SAFE_filelist
#rm -f *.EOF
foreach SAFEfile (`cat $sf`)
  echo $SAFEfile
  set SAFEfile1 = `echo $SAFEfile | awk -F: '{print $1}'`
  set SAFEfile2 = `echo $SAFEfile | awk -F: '{print $2}'`
  echo $SAFEfile1 > SAFE_filelist
  echo $SAFEfile2 >> SAFE_filelist
  set sname=`echo $SAFEfile1 | awk -F / '{print $NF}' | cut -c 1-3`
  set dd = `echo $SAFEfile1 | awk -F / '{print $NF}' | cut -c 18-25`
  
  if ( $os == "Linux") then
    set bdate = `date --date="$dd -1 day" +%Y%m%d`
  else if ($os == "Darwin") then
    set bdate = `date -j -v-1d -f %Y%m%d $dd +%Y%m%d`
  else
    echo "unknown OS"
    exit 1
  endif

  if ($sname == "S1A") then
    set orbitfile = `ls ${ORBITDIR}/S1A_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    create_frame_tops.csh SAFE_filelist $orbitname pins.ll vv
  else if ($sname == "S1B") then
    set orbitfile = `ls ${ORBITDIR}/S1B_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    create_frame_tops.csh SAFE_filelist $orbitname pins.ll vv
  else
    echo "No such file!"
    exit 2
  endif
end
  


