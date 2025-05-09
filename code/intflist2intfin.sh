#! /bin/bash

# created by Zhao Xiangjun 20240621

# if ($#argv != 3) then
	echo ""
	echo "	usage: ./intflist2intfin.csh intf.list intf.in"
	echo "	"
	echo "	convert day number to %date of month"
	echo "	the inputfile format is YYYYddd_YYYYddd, such 2017050_2017062"
	echo "	the output format is S1_YYYYMMDD_ALL_F1:S1_YYYYMMDD_ALL_F1"
# endif
# convert day number to %date of month
# the inputfile contains the day number %in format YYYYddd, such 2017050
# the output format is YYYYMMDD, such as 

inputfile="$1"
outputfile="$2"
rm -f $outputfile
touch $outputfile
number=1
while read -r daynum
do
  year=`echo $daynum | cut -c 1-4`
  day=`echo $daynum | cut -c 5-7`
  dd=`date -d ""$day" days "$year"-01-01" +"%Y%m%d"`
  year=`echo $daynum | cut -c 9-12`
  day=`echo $daynum | cut -c 13-15`
  dd2=`date -d ""$day" days "$year"-01-01" +"%Y%m%d"`
  echo S1_"$dd"_ALL_F2:S1_"$dd2"_ALL_F2 >> $outputfile
  (( number++ ))
done < "$inputfile"
