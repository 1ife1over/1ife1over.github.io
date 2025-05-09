#!/bin/csh -f


if ($#argv != 3) then
  echo ""
  echo "Usage: plot_disp_ll_zxj.csh disp_list limitL limitU"
  echo ""
  echo "    plot grdfile "
  echo "    eg: plot_disp_ll_zxj.csh disp_list -300 100 "
  echo ""
  exit
endif

set displist = $1


# GMT parameters
gmt set MAP_FRAME_WIDTH  0.05 MAP_FRAME_PEN 1.5 MAP_FRAME_TYPE plain FORMAT_GEO_MAP ddd:mm:ss \
MAP_TICK_LENGTH 0.1 MAP_LOGO FALSE FONT_LABEL 12 
###需要自己设置最小最大色带值
set limitU = $3
set limitL = $2
echo colorbar from $limitU to $limitL
gmt makecpt -Cseis -Z -T$limitL/$limitU/5 -D > los_vel.cpt
############################

foreach line (`awk '{print $1}' $displist`)
  ## 设置输入文件名##

  echo "plot $line"
  set vel_file = $line
  set name = `echo $vel_file | awk -F. '{print $1}'`

  set scale = -JM12c

  gmt begin $name jpg
    gmt basemap -R$vel_file $scale -Baf -BWSen
    gmt grdimage $vel_file -Clos_vel.cpt -Q
    gmt colorbar -Dx1.2c/-1.2c+w9c/0.3c+h+e -Clos_vel.cpt -Baf+l"LOS displacement (mm)" --FONT_LABEL=10p
  gmt end 
end
