#!/bin/csh -f
# intflist contains a list of all date1_date2 directories.

set intfile = $1

foreach line (`awk '{print $1}' $intfile`)
  cd $line
  echo "cutting $line"
  gmt grdcut corr.grd -Runwrap.grd -Gcorr_cut.grd
  cd ..
  echo "finish cutting $line"
end
