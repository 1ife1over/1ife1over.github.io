#!/bin/csh -f
# intflist contains a list of all date1_date2 directories.

set intfile = $1
#cd ..
foreach line (`cat $intfile`)
  
  set n1 = `echo $line | awk -F: '{print $1}'`
  set n2 = `echo $line | awk -F: '{print $2}'`
  set n3 = `echo $line | awk -F: '{print $3}'`
  echo "名字" $n1
  echo "主影像"$n2
  echo "副影像"$n3
  #mkdir topo raw
  #ln -s ../config_ALOS2.txt .
  #cd topo
  #ln -s ../../../dem.grd .
  #cd ..
  #cd raw
  cd $n1
  rm -f IMG* LED*
  cd raw
  rm -f IMG* LED*
  ln -s /media/student/MyBookWang1/mayang/$n2/IMG-HH-* .
  ln -s /media/student/MyBookWang1/mayang/$n2/LED* .
  ln -s /media/student/MyBookWang1/mayang/$n3/IMG-HH-* .
  set master = `ls IMG*`
  echo $master
  ln -s /media/student/MyBookWang1/mayang/$n3/LED* .
  cd ..
  p2p_processing.csh ALOS2 $master config_ALOS2.txt
  cd /media/student/MyBookWang1/mayang/intf/
  
  
  
  #cd ..
  #echo "finish convert $line"
end
