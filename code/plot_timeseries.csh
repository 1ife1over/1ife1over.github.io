#!/bin/csh -f

##

if ($#argv != 1) then

	echo "	"

	echo "	usage: ./plot_timeseries.csh name_ts_disp.txt   "

	echo "	"

	echo "	"
	echo "	"
	exit 1
endif

set point1 = $1
set J = -JX15c/5c
gmt set FONT_ANNOT_PRIMARY 6p
gmt set FONT_ANNOT_SECONDARY 8p
gmt set MAP_FRAME_PEN 1p
gmt set FORMAT_DATE_MAP o
gmt set FORMAT_TIME_PRIMARY_MAP abbreviated
gmt set MAP_TICK_LENGTH 4p
set point_name = `echo $point1 | awk -F_ '{print $1}'`
set wesn1 = `gmt info -C $point1 -fT -I50 --FORMAT_DATE_IN=yyyymmdd`
set w1 = `echo $wesn1 | awk '{print $1}'`
set e1 = `echo $wesn1 | awk '{print $2}'`
set s1 = `echo $wesn1 | awk '{print $3}'`
set n1 = `echo $wesn1 | awk '{print $4}'`
set s1 = `expr $s1 - 20`
set n1 = `expr $n1 + 20`
set R1 = -R$w1/$e1/$s1/$n1
echo $R1




gmt begin $point_name png
	gmt basemap $J $R1 -Bsx1Y -Bpxa3Of1o -Byaf+l"Dislacement (mm)" -BnSWe 
	gmt plot $point1 -i0,1 -Sc0.1 -W0.5p,black,solid -Gred --FORMAT_DATE_IN=yyyymmdd 
    #gmt plot $point1 -i0,1 -W0.8p --FORMAT_DATE_IN=yyyymmdd 
    echo $point_name | gmt text $J $R1  -F+cTL -Dj0.1c/0.1c 
    
gmt end 

