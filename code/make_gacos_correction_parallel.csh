#!/bin/csh -f
# 
# By Xiangjun Zhao 2024
#
# 
#

if ($#argv != 2) then
  echo ""
  echo "Usage: umake_gacos_correction_parallel.csh intflist Ncores"
  echo ""
  echo "    Run gacos jobs parallelly. Need to install GNU parallel first."
  echo "    Note, all the interferograms have unwraped. "
  echo ""
  exit
endif

set ncores = $2
set d1 = `date`

foreach line (`awk '{print $0}' $1`)
  echo "./make_gacos_correction.csh $line > log_gacos_$line.txt" >> gacos.cmd
end

parallel --jobs $ncores < gacos.cmd

echo ""
echo "Finished all gacos jobs..."
echo ""

set d2 = `date`

#echo "parallel --jobs $ncores < intf_tops.cmd" | mail -s "Unwrapping finished" "balabala@gmail.com" 
