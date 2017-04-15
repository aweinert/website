#!/bin/sh

rm -r parkinglot
echo "1\nparkinglot\nParking lot in Saarbrücken\n/Users/alexander/Nextcloud/Photos/2017-01-18_Night_0016.jpg\n" | ./main.rb > /dev/null

if [ $? == 0 ]; then
	echo "Exit code .... SUCCESS"
else
	echo "Exit code ....... FAIL"
fi

if [ ! -d "parkinglot" ]; then
	echo "Directory created ....... FAIL"
	exit 1
else
	echo "Directory created .... SUCCESS"
fi

if [ -s "parkinglot/parkinglot-500px.jpg" ]; then
	echo "500px created .... SUCCESS"
	diff "parkinglot/parkinglot-500px.jpg" "soll/parkinglot-500px.jpg"
	if [ $? == 0 ]; then
		echo "500px correct .... SUCCESS"
	else
		echo "500px correct ....... FAIL"
	fi
else
	echo "500px created ....... FAIL"
fi

if [ -s "parkinglot/parkinglot-aw.jpg" ]; then
	echo "AW created .... SUCCESS"
	diff "parkinglot/parkinglot-aw.jpg" "soll/parkinglot-aw.jpg"
	if [ $? == 0 ]; then
		echo "AW correct .... SUCCESS"
	else
		echo "AW correct ....... FAIL"
	fi
else
	echo "AW created ....... FAIL"
fi
if [ -s "parkinglot/parkinglot-fb.jpg" ]; then
	echo "FB created .... SUCCESS"
	diff "parkinglot/parkinglot-fb.jpg" "soll/parkinglot-fb.jpg"
	if [ $? == 0 ]; then
		echo "FB correct .... SUCCESS"
	else
		echo "FB correct ....... FAIL"
	fi
else
	echo "FB created ....... FAIL"
fi
if [ -s "parkinglot/parkinglot-thumb.jpg" ]; then
	echo "Thumb created .... SUCCESS"
	diff "parkinglot/parkinglot-thumb.jpg" "soll/parkinglot-thumb.jpg"
	if [ $? == 0 ]; then
		echo "Thumb correct .... SUCCESS"
	else
		echo "Thumb correct ....... FAIL"
	fi
else
	echo "500px created ....... FAIL"
fi
