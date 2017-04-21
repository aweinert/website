#!/bin/sh

# Execute the code on a single image and verify the output.
# The expected output is expected to be at _test/output_exp/$1-{500px,aw,fb,thumb}.jpg
# $1: Internal id of the picture
# $2: Caption
# $3: Path to the picture, relative to _test/input/
function execute_test() {

	echo "================================="
	echo "Testing $1 ($3)\n"

	cd ..
	echo "1\n$1\n$2\n_test/input/$3\n" | ./main.rb > /dev/null

	if [ $? == 0 ]; then
		echo "Exit code .... SUCCESS"
	else
		echo "Exit code ....... FAIL"
	fi

	if [ ! -d "$1" ]; then
		echo "Directory created ....... FAIL"
		exit 1
	else
		echo "Directory created .... SUCCESS"
	fi

	if [ -s "$1/$1-500px.jpg" ]; then
		echo "500px created .... SUCCESS"
		diff "$1/$1-500px.jpg" "_test/output_exp/$1/$1-500px.jpg"
		if [ $? == 0 ]; then
			echo "500px correct .... SUCCESS"
		else
			echo "500px correct ....... FAIL"
		fi
	else
		echo "500px created ....... FAIL"
	fi

	if [ -s "$1/$1-aw.jpg" ]; then
		echo "AW created .... SUCCESS"
		diff "$1/$1-aw.jpg" "_test/output_exp/$1/$1-aw.jpg"
		if [ $? == 0 ]; then
			echo "AW correct .... SUCCESS"
		else
			echo "AW correct ....... FAIL"
		fi
	else
		echo "AW created ....... FAIL"
	fi
	if [ -s "$1/$1-fb.jpg" ]; then
		echo "FB created .... SUCCESS"
		diff "$1/$1-fb.jpg" "_test/output_exp/$1/$1-fb.jpg"
		if [ $? == 0 ]; then
			echo "FB correct .... SUCCESS"
		else
			echo "FB correct ....... FAIL"
		fi
	else
		echo "FB created ....... FAIL"
	fi
	if [ -s "$1/$1-thumb.jpg" ]; then
		echo "Thumb created .... SUCCESS"
		diff "$1/$1-thumb.jpg" "_test/output_exp/$1/$1-thumb.jpg"
		if [ $? == 0 ]; then
			echo "Thumb correct .... SUCCESS"
		else
			echo "Thumb correct ....... FAIL"
		fi
	else
		echo "Thumb created ....... FAIL"
	fi

	rm -r $1
	cd _test
}

execute_test "parkinglot" "Parking lot in Saarbrücken" "2017-01-18_Night_0016.jpg"
execute_test "beefeater" "Billy Beefeater, London" "2016_london_DSC_0049.jpg"
