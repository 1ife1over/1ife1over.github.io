#!/bin/csh -f



if ($#argv != 3) then
  echo ""
  echo "Usage: plot_grd.csh grd_file limitL limitU"
  echo ""
  echo "    plot grdfile "
  echo "    eg: plot_grd.csh vel.grd -60 20 "
  echo ""
  exit
endif


# GMT parameters
gmt set MAP_FRAME_WIDTH  0.05 MAP_FRAME_PEN 1.5 MAP_FRAME_TYPE plain FORMAT_GEO_MAP ddd:mm:ss \
MAP_TICK_LENGTH 0.1 MAP_LOGO FALSE FONT_LABEL 12 PS_MEDIA A4

## here you have to set to your own parameters
#set input = disp_ll_referenced.list

## 设置输入文件名##
set vel_file = $1
set name = `echo $vel_file | awk -F. '{print $1}'`

########################

## end setting parameters

## look for the mean lon and lat for plotting



set scale = -JM12c

echo plot the velocity 
# look for the range of colorbar
set tmp_info = `gmt grdinfo -C -L2 $vel_file`
set limitU = `echo $tmp_info | awk '{printf("%5.1f", $12+$13*3)}'`
set limitL = `echo $tmp_info | awk '{printf("%5.1f", $12-$13*3)}'`
# or you can set the limitU and limitL manually

###需要自己设置最小最大色带值
set limitU = $3
set limitL = $2
############################
echo colorbar from $limitU to $limitL

gmt makecpt -Cseis -Z -T$limitL/$limitU/5 -D > los_vel.cpt
####设置输入文件ps名
###例如 set a = vel.ps
 set a = $name
#############
gmt begin $name jpg
	gmt basemap -R$vel_file $scale -Baf -BWSen
	gmt grdimage $vel_file -Clos_vel.cpt -Q
	gmt colorbar -Dx1.2c/-1.2c+w9c/0.3c+h+e -Clos_vel.cpt -Baf --FONT_LABEL=10p
gmt end 

