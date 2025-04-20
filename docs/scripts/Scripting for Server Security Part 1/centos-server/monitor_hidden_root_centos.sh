#!/bin/bash

LOG_FILE="/home/radeshiyan/hidden_changes.txt"
NEW_LIST="/home/radeshiyan/new_list.txt"
OLD_LIST="/home/radeshiyan/old_list.txt"


echo "Starting to look at hidden files and root files..."

TODAY=$(date)

# make lists of files
echo "Finding hidden files..." >> $LOG_FILE
sudo find / -name ".*" > /tmp/hidden_files.txt
echo "Finding root files in /bin..." >> $LOG_FILE
ls /bin > /tmp/root_files.txt
cat /tmp/hidden_files.txt /tmp/root_files.txt | sort > $NEW_LIST

echo "===== Checking on $TODAY =====" >> $LOG_FILE

# check if there is an old list
if [ -f $OLD_LIST ]; then
    echo "Old list found, checking for difference.." >> $LOG_FILE
    # check for changes
    diff $OLD_LIST $NEW_LIST > /tmp/diff_temp.txt
    if [ -s /tmp/diff_temp.txt ]; then
        echo "Changes on $TODAY:" >> $LOG_FILE
        cat /tmp/diff_temp.txt >> $LOG_FILE
    else
        echo "No changes found" >> $LOG_FILE
    fi
else
    echo "First run, saving the list" >> $LOG_FILE
fi

# save the new list
echo "Saving the list for next time.." >> $LOG_FILE
mv $NEW_LIST $OLD_LIST

# clean up
rm /tmp/hidden_files.txt /tmp/root_files.txt /tmp/diff_temp.txt
echo "check done"
