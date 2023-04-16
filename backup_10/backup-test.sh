#!/bin/bash

# Create temporary directories for test files and backups
test_dir=$(mktemp -d -p ./ test_dir.XXXXXXXXXX)
backup_dir=$(mktemp -d -p ./ backup_dir.XXXXXXXXXX)

# Create 5 empty test files in the test directory
for i in {1..5}
do
  touch "$test_dir/file$i.txt"
done

# Create 11 backups
for i in {1..11}
do
  ./backup.sh "$test_dir" "$backup_dir"
done

# Check if there are 10 or fewer backup directories
num_backups=$(ls -1 "$backup_dir" | grep "backup_*" | wc -l)
if [ "$num_backups" -le 10 ]
then
  echo "TEST PASSED"
else
  echo "TEST FAILED"
fi

# Remove temporary directories
#rm -rf "$test_dir"
#rm -rf "$backup_dir"
