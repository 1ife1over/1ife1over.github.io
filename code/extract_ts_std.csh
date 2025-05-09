#!/bin/csh -f

#wei tang
# created by tangwei 20171006
#####################################################
gmt set MAP_FRAME_WIDTH  0.05 MAP_FRAME_PEN 1.5 MAP_FRAME_TYPE plain FORMAT_GEO_MAP ddd:mm:ss \
MAP_TICK_LENGTH 0.2 MAP_LOGO FALSE FONT_LABEL 12 PS_MEDIA A4

set points = points.list
set grdlist = disp_referenced.list

#######################################################
# loop over point by point
set i = `cat $points | wc -l`
set j = 1
while ($j <= $i)
  set pp = `cat $points | head -$j | tail -1`
  echo $pp
  set lon = `echo $pp | awk '{print $1}'`
  set lat = `echo $pp | awk '{print $2}'` 
  set name = `echo $pp | awk '{print $3}'`
  echo $name
  echo $lon $lat > point.txt
  rm -f mask.grd disp.grd ${name}_ts_disp.txt
  ## loop over the file
  foreach fl (`cat $grdlist`)
   if (-f $fl ) then
      set grdfile = $fl
      set dat = `echo $fl | cut -c 1-8`
      echo $grdfile
      gmt grdmath -R$grdfile point.txt POINT SDIST = mask.grd
      gmt grdclip mask.grd -Sa0.2/NaN -Sb0.2/1 -Gmask.grd
      gmt grdmath $grdfile mask.grd MUL = disp.grd
      set disp = `gmt grdinfo -C -L2 disp.grd | awk '{print $12}'`
      set std = `gmt grdinfo -C -L2 disp.grd | awk '{print $13}'` 
      echo $dat $disp $std >> ${name}_ts_disp.txt
    endif
  end 
  
  @ j = $j + 1

end

