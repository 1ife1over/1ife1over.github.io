#!/bin/csh -f

# Zhao Xiangjun, Jun 25 2022


if ($#argv != 2) then
	echo ""
	echo "	usage: ./select_phasefilt.csh mode"
	echo "	mode=[1/2]"
	echo "	mode=1,you can cd a folder named "phasefilt_all" to select right phasefilt.grd"
	echo "	mode=2,if mode=1 was completed,run mode=2 to complete the folder selection"
	echo "	if you don't know how to use it,just run it"
endif

ls -d 20* > intf.list
mkdir phasefilt_all
set png = phasefilt_all
set corrthres = 0.15

##select phasefilt
set mode = $1
if($mode == 1) then

	foreach dd (`cat intf.list`)
  		cd $dd
 		echo $dd
		gmt grdmath corr.grd $corrthres GE 0 NAN mask.grd MUL = mask2.grd -V
		if (-e phasefilt.grd) then 
    		gmt grdmath phasefilt.grd mask2.grd MUL = phasefilt_mask.grd
  		endif
  		gmt makecpt -Crainbow -T-3.15/3.15/0.1 -Z -N > phase.cpt
    	gmt grdimage phasefilt_mask.grd -JX6.5i -Rphasefilt.grd -Bxaf+lRange -Byaf+lAzimuth -BWSen -Cphase.cpt -X1.3i -Y3i -P -K > "$dd"_phasefilt.ps
    	gmt psscale -Rphasefilt.grd -J -DJTC+w5i/0.2i+h -Cphase.cpt -Bxa1.57+l"Phase" -By+lrad -O >> "$dd"_phasefilt.ps
    	gmt psconvert -Tg -P -A -Z "$dd"_phasefilt.ps 
  		cp *phasefilt.png ../$png/"$dd".png
  		cd ..
	end 
endif


###select folder
if($mode == 2) then
	cd $png
	ls 20*.png | awk -F. '{print $1}' > selected.list
	mv selected.list ../
	cd ..
	mkdir tmp
	mkdir rm
	foreach dd (`cat selected.list`)
		mv $dd"/" ./tmp/
	end
	ls -d 20* > tmp.list
	foreach dd (`cat tmp.list`)
		mv $dd/ ./rm/$dd/
	end
	foreach dd (`cat selected.list`)
		cd tmp
		mv $dd"/" ../
		cd ..
	end
	#rm tmp tmp.list
endif




