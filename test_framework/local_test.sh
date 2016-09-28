#!/bin/bash
set -eu
MAPPER=$(readlink -f $1)
REDUCER=$(readlink -f $2)
TEST_DIR=$(readlink -f $3)

function local_test_map_reduce(){
	echo "TEST"
	echo "-------------------------------------------------------"
	echo "Testing with input file $1"
	file_name=$(basename $1 .input)
	echo "Mapper = $2"
	echo "Reducer = $3"
	cat $1 | $2 | sort -k 1 | $3 | sort -k 1 > "$4/$file_name.result"
	echo "Comparing results"
	if cmp -s "$4/$file_name.result" "$4/$file_name.output"
	then
		printf "Test passed.\nThe test with input $1 passed\n"
	else
		printf "Test failed.\nThe test with input $1 failed\n"
		echo "------> For debugging:"
		echo "diff $4/$file_name.result" "$4/$file_name.output"
		exit
	fi
	echo "-------------------------------------------------------"
	echo ""
}

for f in $TEST_DIR/*.input
do
	local_test_map_reduce $f $MAPPER $REDUCER $TEST_DIR	
done
echo "All tests passed"

