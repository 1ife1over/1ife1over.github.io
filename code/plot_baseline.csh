#!/bin/csh -f

#Zhao Xiangjun 2022-09-14

if ($#argv != 2) then
	echo ""
	echo "	usage: plot_baseline.csh intf.in baseline_table.dat"
	echo "	come on!"
	exit 1
endif

set intf_in = $1
set baseline = $2
set line_file = baseline_data.txt
rm $line_file
foreach line (`cat $intf_in`)
	set t1 = `echo $line | awk -F: '{print $1}' | cut -c 4-11`
	set t2 = `echo $line | awk -F: '{print $2}' | cut -c 4-11`
	set b1 = `grep $t1"_ALL" $baseline  | awk '{print $5}'`
	set b2 = `grep $t2"_ALL" $baseline  | awk '{print $5}'`
	#echo $b1 $b2
	echo $t1 $b1 >> $line_file
	echo $t2 $b2 >> $line_file
	echo ">" >> $line_file

end


gmt set FONT_ANNOT_PRIMARY 6p
gmt set FONT_ANNOT_SECONDARY 8p
gmt set MAP_FRAME_PEN 0.5p
gmt set FORMAT_DATE_MAP o
gmt set FORMAT_TIME_PRIMARY_MAP abbreviated
gmt set MAP_TICK_LENGTH 4p

set point1 = $line_file
set J = -JX15c/8c
set point_name = `echo $point1 | awk -F_ '{print $1}'`
set wesn1 = `gmt info -C $point1 -fT -I50 --FORMAT_DATE_IN=yyyymmdd`
set w1 = `echo $wesn1 | awk '{print $1}'`
set e1 = `echo $wesn1 | awk '{print $2}'`
set s1 = `echo $wesn1 | awk '{print $3}'`
set n1 = `echo $wesn1 | awk '{print $4}'`
set s1 = `expr $s1 - 20`
set n1 = `expr $n1 + 20`


set w1 = `date --date="$w1" +%Y%m%d`
set e1 = `date --date="$e1" +%Y%m%d`
set w1 = `date --date="$w1 -90 day" +%Y%m%d`
set e1 = `date --date="$e1 +90 day" +%Y%m%d`
set w1 = `date --date="$w1" +%Y-%m-%dT%H:%M:%S`
set e1 = `date --date="$e1" +%Y-%m-%dT%H:%M:%S`
set R1 = -R$w1/$e1/$s1/$n1


gmt begin $point_name png
	gmt basemap $J $R1 -Bsx1Y -Bpxa6Of1o -Byaf+l"Baseline (m)" -BnSWe --FONT=10p
	gmt plot $point1 -i0,1 -Sc0.08 -Gblack --FORMAT_DATE_IN=yyyymmdd 
	gmt plot $point1 -i0,1 -W0.3p -Gblack --FORMAT_DATE_IN=yyyymmdd
    #gmt plot $point1 -i0,1 -W0.8p --FORMAT_DATE_IN=yyyymmdd 
    #echo $point_name | gmt text $J $R1  -F+cTL -Dj0.1c/0.1c 
    
gmt end 

