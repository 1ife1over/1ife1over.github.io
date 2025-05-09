#!/bin/csh -f

rm tmp.list
ls disp_20* > tmp.list

foreach dd (`cat tmp.list`)
	echo $dd
	set year = `echo $dd | cut -c 6-9`
	set day = `echo $dd | cut -c 10-12`
	set date = `date -d ""$day" days "$year"-01-01" +"%Y%m%d"`
	echo $date 
	mv $dd $date".grd"
end

mkdir aps

mv aps*grd aps

ls 20*grd | awk -F. '{print $1}' > disp_ra.list

