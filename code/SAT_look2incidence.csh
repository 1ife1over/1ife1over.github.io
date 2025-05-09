#!/bin/csh -f 

##
if ($#argv < 3) then
	echo "usage: SAT_look2incidence.csh master.PRM inputfile outputfile  "

	echo "       master.PRM   -  parameter file for master image and points to LED orbit file "
	echo "       inputfile    -  lon, lat, elevation [ASCII] "
	echo "       outputfile   -  lon, lat, elevation look_E look_N look_U incidence*[ASCII default] "
	echo "       -bos or -bod -  binary single or double precision output"
	exit 1
endif

#
rm tmp.txt
SAT_look $1 < $2 > $3

echo finish
#foreach line (`cat $3`)
#foreach line (`awk '{print}' $3`)
foreach line (`awk '{print $0}'  < $3`)

set file = $3
set n = `wc -l $3 | awk '{print $1}'`
echo n= $n
set i = 1
while ($i <= $n)
	set line = "`awk '{if (NR == $i) print}' $file`"
	echo $line
	set lon = `echo $line | awk '{print $1}'`
	set lat = `echo $line | awk '{print $2}'`
	set lookE = `echo $line | awk '{print $4}'`
	set lookE = `echo $line | awk '{print $4}'`
	set lookN = `echo $line | awk '{print $5}'`
	set lookU = `echo $line | awk '{print $6}'`
	set incid = `echo "$lookE $lookN $lookU" | awk '{ rad = atan2(sqrt($1*$1 + $2*$2), $3); deg = rad * (180 / 3.141592653589793); printf "%f", deg }'`
	
	echo $lon $lat $incid >> tmp.txt

	@ i++
end
mv tmp.txt $3




