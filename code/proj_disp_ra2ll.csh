#!/bin/csh -f

#wei tang
# modified by weitang 20171006
# modified by Xiangjun Zhao 20240912
# geocode: convert the displacement from radar coordinate(range, azimuth) to gegraphical coordinate(longitude, latitude)

#####################################################

if ($#argv == 0) then
    echo ""
    echo "Usage: proj_disp_ra2ll.csh disp_ra.list mask_file"
    echo ""
    echo "Example: proj_disp_ra2ll.csh disp_ra.list mask_def.12.grd"
    echo "			convert the displacement from radar coordinate(range, azimuth) "
    echo "			to gegraphical coordinate(longitude, latitude)"	
    echo ""
    echo ""
    exit 1
  endif
#
set intput = $1
# the mask file
set maskgrd = $2
set vel_file = vel.grd
#####################################################
echo Start geocoding cumulative displacements!
foreach fl (`cat $intput`)
  if (-f $fl".grd") then
   set disp_file = $fl".grd"
   echo Project $disp_file
   #mask
   echo "Mask out the decorrelated pixels."
   gmt grdmath $disp_file $maskgrd MUL = $fl"_mask.grd"

   #transform to geographical lonlat
   proj_ra2ll.csh trans.dat $fl"_mask.grd" $fl"_mask_ll.grd"
   
   rm -f $fl"_mask.grd"
   #detrend
   #gmt grdtrend $fl"_mask_ll.grd" -N3r -D$fl"_mask_ll.grd"
   else
     echo File $disp_file does not exist!
  endif
end

echo Finish geocoding cumulative displacements!

##################################################################################
echo
echo
echo 
#####################################################
# Srart geocoding velocity!
echo "Mask out the decorrelated pixels."
gmt grdmath $vel_file $maskgrd MUL = vel_mask.grd

#transform to geographical lonlat
proj_ra2ll.csh trans.dat vel_mask.grd vel_mask_ll.grd

#rm -f vel_mask.grd

ls 20*ll.grd | awk -F. '{print $1}' > disp_ll.list

echo Finish geocoding velocity!
