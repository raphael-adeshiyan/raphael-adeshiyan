#!/bin/bash

# variables
CHECK_FOLDER="/etc"
OLD_HASH_FILE="/home/raphael/old_etc_hash.txt"
NEW_HASH_FILE="/home/raphael/new_etc_hash.txt"
LOG_FILE="/home/raphael/etc_log.txt"


echo "Checking /etc"

# make a new hash file
echo "Making a hash for all files in /etc..." >> $LOG_FILE
find $CHECK_FOLDER -type f > /tmp/file_list.txt
cat /tmp/file_list.txt | while read FILE; do
    sha256sum "$FILE" >> $NEW_HASH_FILE
done
sort $NEW_HASH_FILE > /tmp/sorted_hash.txt
mv /tmp/sorted_hash.txt $NEW_HASH_FILE

echo "===== Check on $(date) =====" >> $LOG_FILE

# see if there’s an old hash
if [ -f $OLD_HASH_FILE ]; then
    echo "found an old hash" >> $LOG_FILE

    # compare them with diff
    diff $OLD_HASH_FILE $NEW_HASH_FILE > /tmp/hash_diff.txt
    if [ -s /tmp/hash_diff.txt ]; then
        echo "Changes happened on $(date)" >> $LOG_FILE
        echo "Current Content Hash" >> $LOG_FILE
        cat $NEW_HASH_FILE | cut -d' ' -f3- >> $LOG_FILE
    else
        echo "No changes" >> $LOG_FILE
    fi
else
    echo "No old has found"
fi

echo "Saving the new hash file..." >> $LOG_FILE
mv $NEW_HASH_FILE $OLD_HASH_FILE