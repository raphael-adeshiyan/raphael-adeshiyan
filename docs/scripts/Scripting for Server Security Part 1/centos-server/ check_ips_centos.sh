#!/bin/bash

LOG="/var/log/secure"
OUTPUT="/home/radeshiyan/ip_report.txt"
USER="radeshiyan"

# set the date for today
TODAY=$(date +%b\ %d)

echo "IP Report for $TODAY" > $OUTPUT
echo "" >> $OUTPUT

# look for attempts between midnight and 6am
echo "Starting to check logins between midnight and 6am" >> $OUTPUT
sudo cat $LOG | grep "$TODAY" | grep -E " 00:| 01:| 02:| 03:| 04:| 05:" | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" | sort | uniq >> $OUTPUT
echo "" >> $OUTPUT

# check logins for my user
echo "Checking logins for user $USER" >> $OUTPUT
sudo cat $LOG | grep "$TODAY" | grep "$USER" | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" | sort | uniq >> $OUTPUT
echo "" >> $OUTPUT

# look for lots of failed logins
echo "Looking for IPs with multiple failed logins" >> $OUTPUT
sudo cat $LOG | grep "$TODAY" | grep "Failed" | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" | sort | uniq -c | grep -v " 1 " >> $OUTPUT
echo "" >> $OUTPUT

echo "Checking if $USER logs in from too many IPs today" >> $OUTPUT
sudo cat $LOG | grep "$TODAY" | grep "Accepted" | grep "$USER" | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" | sort | uniq > /tmp/my_ips.txt
echo "Counting how many IPs found" >> $OUTPUT
cat /tmp/my_ips.txt | wc -l > /tmp/ip_number.txt
IP_NUM=$(cat /tmp/ip_number.txt)
echo "Found $IP_NUM IPs for $USER today" >> $OUTPUT
if [ $IP_NUM -gt 3 ]; then
    echo "$USER used $IP_NUM IPs" >> $OUTPUT

    cat /tmp/my_ips.txt >> $OUTPUT
else
    echo "Only $IP_NUM IPs" >> $OUTPUT
fi
echo "Check is done" >> $OUTPUT
echo "" >> $OUTPUT

echo "Report done on $(date)" >> $OUTPUT