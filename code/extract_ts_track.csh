#!/bin/csh -f

### Zhao Xiangjun

set points = points.list
set grdlist = disp_referenced.list

#foreach point (`cat $point`)
#	echo $point
#	set name = `echo $point | awk '{print $3}'`
#	echo $name
#	foreach fl (`cat $input`)
#		echo $fl
#		gmt grdtrack tmp.txt -G$fl > tmp.txt
#		set value = `cat tmp.txt | awk '{print $3}'`
#		set dat = `echo $fl | cut -c 1-8`
#		echo $dat $value >> "$name"_ts_track.txt
#	end
#end
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
      gmt grdtrack point.txt -G$grdfile > tmp.txt
      set value = `cat tmp.txt | awk '{print $3}'`
	  set dat = `echo $fl | cut -c 1-8`
	  echo $dat $value >> ${name}_ts_track.txt
    endif
  end 
  
  @ j = $j + 1

end
