#!/bin/csh -f
# intflist contains a list of all date1_date2 directories.

set intfile = $1

foreach line (`awk '{print $1}' $intfile`)
  cd $line
  rm -f trans.dat raln.grd ralt.grd
  ln -s ../trans.dat .
  cd ..
  echo "finish $line"
end
