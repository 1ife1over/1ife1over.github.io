#! /bin/csh -f 
#this script is used to create ENVISAT directory before doris
#before use this script do this:

ls ASA* | cut -c 15-22 > dates.list


foreach dd (`cat dates.list`)
mkdir -p $dd
mv *$dd*.N1 ./$dd
end
