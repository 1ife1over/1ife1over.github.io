#!/bin/csh -f

# 



if ($#argv != 2)then
    echo ""
    echo "Usage: mask_meancorr.csh meancorr.grd thresholds"
    echo ""
    echo "Example: mask_meancorr.csh meancorr.grd 0.12"
    echo ""
    echo ""
    exit 1
endif
  


set meancorr = $1
set thresholds = $2


gmt grdmath $1 $2 GE 0 NAN = "mask_def"$2".grd"

echo
echo "### END ###"
