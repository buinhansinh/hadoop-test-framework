#!/bin/bash
set -eu
HADOOP_DIR=$(readlink -f $4)
MAPPER=$(readlink -f $1)
REDUCER=$(readlink -f $2)
TEST_DIR=$(readlink -f $3)

function hadoop_test_map_reduce(){
	echo "TEST"
	echo "-------------------------------------------------------"
	echo "Testing with input file $1"
	file_name=$(basename $1 .input)
	output_dir=$(mktemp -d -t $file_name.XXXXXXXXXXXX)
	rm -r $output_dir
	echo "Mapper = $2"
	echo "Reducer = $3"
	echo "Starting executing hadoop job"
	$HADOOP_DIR/bin/hadoop jar $HADOOP_DIR/share/hadoop/tools/lib/hadoop-streaming-2.7.3.jar -input $1 -output $output_dir -mapper $(basename $2) -reducer $(basename $3) -file $2  -file $3
	echo "Merging result"
	$HADOOP_DIR/bin/hadoop fs -getmerge $output_dir "$4/$file_name.result.tmp"
	cat "$4/$file_name.result.tmp" | sort -k1 > "$4/$file_name.result"
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
	hadoop_test_map_reduce $f $MAPPER $REDUCER $TEST_DIR	
done
echo "All tests passed"

