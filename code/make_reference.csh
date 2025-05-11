#!/bin/csh -f

#wei tang
# modified by tangwei 20171006
# use this script, you first need to project the displacement into geographic coordinate

## here you have to set to your own parameters
set input = disp_ll.list
set vel_file = vel_mask_ll.grd
# the reference point(area) in the lonlat coordinate
# reference point
set ref_lon = 112.76293  
set ref_lat = 37.6897
## end setting parameters

echo Reference point $ref_lon $ref_lat
echo $ref_lon $ref_lat > refpoint.txt

#######################################################
echo Start referencing cumulative displacements!
foreach fl (`cat $input`)
  if (-f $fl".grd") then
    # refercen to the reference point (area with 200 m radius)
    rm -f ref.grd ref_mask.grd
    gmt grdmath -R$fl".grd" refpoint.txt POINT SDIST = mask.grd
    gmt grdclip mask.grd -Sa0.2/NaN -Sb0.2/1 -Gmask.grd
    gmt grdmath $fl".grd" mask.grd MUL = ref.grd
    set ref_val = `gmt grdinfo -C -L2 ref.grd | awk '{print $12}'`
    echo $ref_val > ref.txt
    echo "reference point value in $fl is $ref_val"
   
    # referencing
    gmt grdmath $fl".grd" $ref_val SUB = $fl"_referenced.grd"
    rm -f ref.grd ref_mask.grd
  else
    echo File $fl".grd" does not exist!
  endif
end

echo Finish referencing cumulative displacements!


##################################################################################
echo
echo
echo 
#####################################################
# Srart referencing velocity!
#####################################################
# refercen to the reference point (200 m radius)
rm -f ref.grd mask.grd
gmt grdmath -R$vel_file refpoint.txt POINT SDIST = mask.grd
gmt grdclip mask.grd -Sa0.2/NaN -Sb0.2/1 -Gmask.grd
gmt grdmath $vel_file mask.grd MUL = ref.grd
set ref_val = `gmt grdinfo -C -L2 ref.grd | awk '{print $12}'`
echo "reference point value is $ref_val"
   
gmt grdmath $vel_file $ref_val SUB = vel_mask_ll_referenced.grd

ls 20*referenced.grd > disp_referenced.list

echo Finish referencing velocity!

