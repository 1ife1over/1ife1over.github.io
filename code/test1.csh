#!/bin/csh -f

#  Xiangjun Zhao, Aug 13, 2021

if ($#argv == 0) then
   echo ""
   echo "Usage:test1.csh Sentinel-1/data/path Sentinel-1_orbits/path"
   echo ""
   echo "example: ./test1.csh /media/student/MyBookZhao1/ /media/student/MyBookZhao1/orbits"
   echo ""
   echo "                  ***you must have a dem.grd in this fonder***"  
   echo "                This script can create the necessary directories    "
   echo "   and link the subswatch files and orbits files to the corresponding locations"
   echo ""
   echo "        batch_tops.config can be found in: /usr/local/GMTSAR/gmtsar/csh"
   exit 1
 endif

if ($#argv > 0) then
   set path1 = $argv[1]
endif

if ($#argv > 1) then
   set path2 = $argv[2]
endif

#if ($#argv > 2) then
#   set subswath = $argv[3]

set location = `pwd`

mkdir topo F1 F2 F3 SBAS merge
mkdir F1/raw F1/topo
mkdir F2/raw F2/topo
mkdir F3/raw F3/topo

#copy batch_tops.config file
cd F1
cp /media/student/MyBookZhao1/TY_S1_P113_processing/F1/batch_tops.config .
cd ../F2
cp /media/student/MyBookZhao1/TY_S1_P113_processing/F1/batch_tops.config .
cd ../F3
cp /media/student/MyBookZhao1/TY_S1_P113_processing/F1/batch_tops.config .
cd ..

mv -f dem.grd $location/topo
cd F1/topo
ln -s ../../topo/dem.grd .
cd ../../F2/topo
ln -s ../../topo/dem.grd .
cd ../../F3/topo
ln -s ../../topo/dem.grd .
cd ../../F1/raw
ln -s ../../topo/dem.grd .
cd ../../F2/raw
ln -s ../../topo/dem.grd .
cd ../../F3/raw
ln -s ../../topo/dem.grd .
cd ../../merge
ln -s ../topo/dem.grd .
cd ..


###link_S1.csh

cd $location/F1/raw
ls -d $path1/*.SAFE > files.list
foreach sfile (`cat files.list`)
  echo info :$sfile
  # link the xml files in the annotation directory
  ln -s ${sfile}/annotation/s1[ab]-iw1-slc-vv-* .
  ln -s ${sfile}/measurement/s1[ab]-iw1-slc-vv-*.tiff .
  rm -f files.list
end

cd $location/F2/raw
ls -d $path1/*.SAFE > files.list
foreach sfile (`cat files.list`)
  echo info :$sfile
  # link the xml files in the annotation directory
  ln -s ${sfile}/annotation/s1[ab]-iw2-slc-vv-* .
  ln -s ${sfile}/measurement/s1[ab]-iw2-slc-vv-*.tiff .
  rm -f files.list
end

cd $location/F3/raw
ls -d $path1/*.SAFE > files.list
foreach sfile (`cat files.list`)
  echo info :$sfile
  # link the xml files in the annotation directory
  ln -s ${sfile}/annotation/s1[ab]-iw3-slc-vv-* .
  ln -s ${sfile}/measurement/s1[ab]-iw3-slc-vv-*.tiff .
  rm -f files.list
end


###link_S1_orbits.csh

cd $location/F1/raw

rm *.EOF
rm -f tiff.list
rm -f orbit.list
rm -f dates.list

set os = `uname -s`

ls *-iw[123]-slc-vv-*.tiff | awk -F '.' '{print $1}' > tiff.list
cat tiff.list | cut -c 16-23 > dates.list

foreach tiffname (`cat tiff.list`)
  set sname = `echo $tiffname | cut -c 1-3`
  set dd = `echo $tiffname | cut -c 16-23`
  if ( $os == "Linux") then
    set bdate = `date --date="$dd -1 day" +%Y%m%d`
  else if ($os == "Darwin") then
    set bdate = `date -j -v-1d -f %Y%m%d $dd +%Y%m%d`
  else
    echo "unknown OS"
    exit 1
  endif

  if ($sname == "s1a") then
    echo "info: link S1A orbits"
    set orbitfile = `ls ${path2}/S1A_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    echo $orbitname >> orbit.list
   else if ($sname == "s1b") then
    echo "info: link S1B orbits"
    set orbitfile = `ls ${path2}/S1B_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    echo $orbitname >> orbit.list
  else
    echo "No such file! ${tiff}"
    exit 2
  endif
end

#paste -d\: tiff.list orbit.list > temp1
#paste dates.list temp1 | sort -k 1 > temp2
#cat temp2 | awk '{print $2}' > data.in
paste -d\: tiff.list orbit.list > data.in
rm -f tiff.list orbit.list


cd $location/F2/raw

rm *.EOF
rm -f tiff.list
rm -f orbit.list
rm -f dates.list

set os = `uname -s`

ls *-iw[123]-slc-vv-*.tiff | awk -F '.' '{print $1}' > tiff.list
cat tiff.list | cut -c 16-23 > dates.list

foreach tiffname (`cat tiff.list`)
  set sname = `echo $tiffname | cut -c 1-3`
  set dd = `echo $tiffname | cut -c 16-23`
  if ( $os == "Linux") then
    set bdate = `date --date="$dd -1 day" +%Y%m%d`
  else if ($os == "Darwin") then
    set bdate = `date -j -v-1d -f %Y%m%d $dd +%Y%m%d`
  else
    echo "unknown OS"
    exit 1
  endif

  if ($sname == "s1a") then
    echo "info: link S1A orbits"
    set orbitfile = `ls ${path2}/S1A_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    echo $orbitname >> orbit.list
   else if ($sname == "s1b") then
    echo "info: link S1B orbits"
    set orbitfile = `ls ${path2}/S1B_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    echo $orbitname >> orbit.list
  else
    echo "No such file! ${tiff}"
    exit 2
  endif
end

#paste -d\: tiff.list orbit.list > temp1
#paste dates.list temp1 | sort -k 1 > temp2
#cat temp2 | awk '{print $2}' > data.in
paste -d\: tiff.list orbit.list > data.in
rm -f tiff.list orbit.list

cd $location/F3/raw

rm *.EOF
rm -f tiff.list
rm -f orbit.list
rm -f dates.list

set os = `uname -s`

ls *-iw[123]-slc-vv-*.tiff | awk -F '.' '{print $1}' > tiff.list
cat tiff.list | cut -c 16-23 > dates.list

foreach tiffname (`cat tiff.list`)
  set sname = `echo $tiffname | cut -c 1-3`
  set dd = `echo $tiffname | cut -c 16-23`
  if ( $os == "Linux") then
    set bdate = `date --date="$dd -1 day" +%Y%m%d`
  else if ($os == "Darwin") then
    set bdate = `date -j -v-1d -f %Y%m%d $dd +%Y%m%d`
  else
    echo "unknown OS"
    exit 1
  endif

  if ($sname == "s1a") then
    echo "info: link S1A orbits"
    set orbitfile = `ls ${path2}/S1A_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    echo $orbitname >> orbit.list
   else if ($sname == "s1b") then
    echo "info: link S1B orbits"
    set orbitfile = `ls ${path2}/S1B_OPER_AUX_POEORB_OPOD_*.EOF | grep V${bdate}T`
    ln -s $orbitfile .
    set orbitname = `basename $orbitfile`
    echo $orbitname >> orbit.list
  else
    echo "No such file! ${tiff}"
    exit 2
  endif
end

#paste -d\: tiff.list orbit.list > temp1
#paste dates.list temp1 | sort -k 1 > temp2
#cat temp2 | awk '{print $2}' > data.in
paste -d\: tiff.list orbit.list > data.in
rm -f tiff.list orbit.list

####preprocess data
cd $location/F1/raw
preproc_batch_tops.csh data.in dem.grd 1
cd $location/F2/raw
preproc_batch_tops.csh data.in dem.grd 1
cd $location/F3/raw
preproc_batch_tops.csh data.in dem.grd 1














