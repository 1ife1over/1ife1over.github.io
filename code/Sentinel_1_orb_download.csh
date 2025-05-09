#!/bin/csh -f





if ($#argv != 1) then
    echo ""
    echo "Usage: ./Sentinel_1_orb_download.csh filelist "
    echo "  没下载的下载，下载的链接过来，并把下载的存入总轨道文件夹中"
    echo ""
    echo "filest:"
    echo "    pth_filename1"
    echo "    pth_filename2"
    echo "    ......"
    echo ""
	exit 1
endif
#设置网站
set url_root = "https://s1qc.asf.alaska.edu/aux_poeorb"
#设置下载目录
set orb_dir = "/home/student/Sentinel-1_orbits"
#查询轨道目录
if (! -f orbits.list) then
  wget $url_root -O orbits.html
  grep EOF orbits.html | awk -F'"' '{print $2}' > orbits.list
  rm orbits.html
endif

#set mode = $3

if (-f tmprecord) rm tmprecord

# divide the list of files into sets, and create frames based on the given pins
foreach line (`awk '{print $0}' $1`)
	set file1 = `echo $line | awk -F"," '{print $1}'`
	echo $file1
    set date1 = `echo $file1 | awk '{print substr($1,length($1)-54,8)}'`
	echo $date1
    set SAT1 = `echo $file1 | awk '{print substr($1,length($1)-71,3)}'`
	echo $SAT1

	# get the orbit file names and download
    #set n1 = `date -v-1d -jf "%Y%m%d" $date1 +%Y%m%d`
    #set n2 = `date -v+1d -jf "%Y%m%d" $date1 +%Y%m%d`
    set n1 = ` date --date="$date1 - 1 day" +%Y%m%d `
    set n2 = ` date --date="$date1 + 1 day" +%Y%m%d `
	set orb = `grep $SAT1 orbits.list | grep $n1 | grep $n2 | head -1`
	echo $orb
	echo $n1 $n2 $orb
	if ($orb == "") then
         echo ""
         echo "SKIP $date1, as precise orbit file does not exist ..."
         echo ""
	endif
	#if (! -f $orb) then
    if (-f $orb_dir/$orb) then
		#echo caonima
        ln -s $orb_dir/$orb .
    else
            #wgetasf $url_root"/"$orb
		wget --http-user=cumtbuzi --http-password=Zxj1861134... $url_root"/"$orb
		mv $orb $orb_dir
		ln -s $orb_dir/$orb .
    endif
       # endif
end
