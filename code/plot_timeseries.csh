#!/bin/csh -f

## Zhao Xiangjun

gmt set MAP_TICK_LENGTH 3p MAP_FRAME_PEN 0.9
gmt set FORMAT_DATE_IN yyyymmdd FORMAT_DATE_MAP o FORMAT_TIME_PRIMARY_MAP abbreviated
gmt set FONT_ANNOT_PRIMARY 8p,Helvetica,black FONT_ANNOT_SECONDARY 10p,Helvetica,black FONT_LABEL 10p,Helvetica-Bold



#foreach point (`cat $1`)

# plot P1
	set point = $1
	echo plot $point
	set name = `echo $point | awk -F. '{print $1}'`
	set wesn = `gmt info -C $point -fT -I10 --FORMAT_DATE_IN=yyyymmdd`
	set w = `echo $wesn | awk '{print $1}'`
	set e = `echo $wesn | awk '{print $2}'`
	set s = `echo $wesn | awk '{print $3}'`
	set n = `echo $wesn | awk '{print $4}'`
	# set the limit of axis a little big larger for better visualization
	@ s = $s - 10
	@ n = $n + 10
	set R = -R$w/$e/$s/$n
	echo $R
	gmt begin $name png
		gmt basemap $R -JX10c/4c -Bsx1Y -Bpxa3Of1o -Byaf+l"Displacement(mm)" -BWSen 
		gmt plot  $point -Sc0.1 -W0.5p,black,solid -Gred 
		#echo "20171201 100 P1" | gmt pstext -R -J -N -F+f8p,Helvetica,black+jLB -K -O -P >> $psout
	gmt end show
#end






