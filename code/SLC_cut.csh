#!/bin/csh -f

# Zhao Xiangjun 20250314

if ($#argv != 1) then
	echo ""
	echo "	usage: ./SLC_cut.csh SLC_path"
	echo "	  "
	echo "	such as:  ./SLC_cut.csh ../SLC "
	echo "	The original SLC exists in another file,"
	echo "  The original SLC dimensions are located on Lines 1(y) and 26(x) of the *PRM"
	echo "  and the current script should run in "raw""
	exit
endif

set slc_path = $1

echo $slc_path

ls $slc_path/*ALL*SLC | awk -F/ '{print $NF}'> SLC.list

foreach line (`awk '{print $1}' SLC.list`)
  
  set name = `echo $line | awk -F. '{print $1}'`
  echo "cutting $name"
  ln -s $slc_path/$name".SLC" .
  ln -s $slc_path/$name".PRM" .
  ln -s $slc_path/$name".LED" .
  cut_slc $name".PRM" $name"_new" 0/15851/3282/12192
 
  echo "finish cutting $name"
  rm $name".PRM" $name".SLC"
  mv $name"_new.PRM" $name".PRM"
  mv $name"_new.SLC" $name".SLC"
  
end
