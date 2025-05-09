#!/bin/csh -f

###zhaoxiangjun
##预处理GLDAS水文模型

set input = tif.list

echo Star convert!!!

foreach fl (`cat $input`)
	if (-f $fl".tif") then
		set name = `echo $fl | cut -c 23-30`
		echo doing $name
		gdal_translate -of GMT $fl".tif" $name".nc"
		gmt grdconvert $name".nc" $name".grd"
		rm -f $name".nc"
	else
		echo file $fl".tif" does not exist!
	endif
end

echo Finish convert!!!
