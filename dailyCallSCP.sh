#!/bin/sh
## Author: Charles Bastian
## 2012.12.09

## Create Variables
yestDay=$(date --date="yesterday" +"%d")
yestMonth=$(date --date="yesterday" +"%m")
yestYear=$(date --date="yesterday" +"%Y")

## Check that local directories exist
## Create them if not
if [ ! -d "$DIRECTORY" ]; then
	mkdir -p /root/CharlesTestDir/scpTest/${yestYear}/${yestMonth}
fi

## Check that remote directories exist
## Create them if not
ssh -o "StrictHostKeyChecking no" root@172.20.250.1 << ENDHERE
	if [ ! -d /opt/0.8-CallRecordings/"${yestYear}"/"${yestMonth}" ]; then
		echo "creating new directory!"
		mkdir -p /opt/0.8-CallRecordings/${yestYear}/${yestMonth}
	fi
	exit
ENDHERE

## Move files to temp local directory if 1 day or older
find /var/spool/asterisk/monitor/ -type f -mtime 1 -exec mv {} /root/CharlesTestDir/scpTest/${yestYear}/${yestMonth} \;
find /var/spool/asterisk/monitor/ -type f -mtime +1 -exec mv {} /root/CharlesTestDir/scpTest/${yestYear}/${yestMonth} \;

## Copy all files in local directory to FTP server
find /root/CharlesTestDir/scpTest/${yestYear}/${yestMonth} -type f -exec scp {} root@172.20.250.1:/opt/0.8-CallRecordings/${yestYear}/${yestMonth} \;
