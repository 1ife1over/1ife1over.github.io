#!/bin/csh -f
# intflist contains a list of all date1_date2 directories.

set intfile = $1
cd $intfile
echo "unwrapping $intfile"
rm -f mask_def.grd
ln -s ../mask_def.grd .
snaphu.csh 0.2 0 12282/24564/0/5481
cd ..
echo "finish unwrapping $line"

