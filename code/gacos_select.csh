#!/bin/csh -f
# intflist contains a list of all date1_date2 directories.
# Zhao Xiangjun 20240914

set intfile = $1

mkdir GACOS_result

foreach line (`awk '{print $1}' $intfile`)
  cd $line
  echo "move $line"
  cp Correction_results.jpg ../GACOS_result/$line".jpg"
  cd ..
  
end
