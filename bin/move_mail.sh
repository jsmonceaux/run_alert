#!/bin/bash

# create a filename for email that included address and timestamp
function get_filename {
  # parse out address from original email
  location=$(pdfgrep 'Location:' $1 | sed 's/: /:/g' | cut -d: -f 2 | sed 's/\s\s/+/g' | cut -d+ -f1 | sed 's/ /_/g' | sed 's/\//-/g')

  # add timestamp to address and with file extension
  echo $location$(date +"_%Y%m%d%H%M%S%N.PDF")
}

# add incident number to web portal
function add_incident_number {
  # get nature of incident from report
  nature=$(pdfgrep 'Nature' $1 | head -n1 | sed 's/:/: /g' | sed 's/\s\s/+/g' | cut -d+ -f3 | cut -d "-" -f1)

  # get location of incident from report
  location=$(pdfgrep 'Location' $1 | sed 's/: /:/g' | cut -d: -f 2 | sed 's/\s\s/+/g' | cut -d+ -f1 | sed 's/\//-/g')

  # get time of incident from report
  datetime=$(pdfgrep 'Call Received' $1 | cut -d: -f 2-4 | cut -dT -f1 | { read input; date +"%F %T" -d "$input"; })

  # send information to web portal
  curl -X POST -F "call[alert]=9hh2Wjq8L83hoVpiBHKzQZY1K9jlHhxX" -F "call[call_type]=${nature}" -F "call[call_location]=${location}" -F "call[created_at]=${datetime}" https://portal.bentonfire.org/calls
  echo ""
}

# test smb and mount if not connected
function mount_smb {
  # get a file count from the folder that is mounted.
  count=$(ls /mnt/local_share | wc -l)

  # test if file count is more than 0
  if (($count < 1))
  then
    # no files means folder isn't mounted and mounts smb folder
    sudo mount -t cifs -o uid=1000,gid=1000 -o vers=1.0 -o username=netadmin,password=Am9hz7*9 //10.20.12.9/times/inbox /mnt/local_share/
  fi
}

# set variable for location of new emails
folder="/home/pi/mail/INBOX/new"

# create variable with list of new emails
emails=$(grep -rl bossier $folder)

# run function to make sure smb is mounted
mount_smb

# loop through new emails
for i in $emails; do
  # split attachments from email
  munpack $i -q > file.txt

  # find pdf file name
  file="$(cat file.txt | cut -d " " -f 1 | grep PDF)"

  # add read priviledges to pdf file
  chmod +r $file

  # add incident number to web portal
  add_incident_number $file

  # update file name with location
  filename=$(get_filename $file)

  # print filename to log
  echo $filename

  # get time of incident from report
  new_time=$(pdfgrep 'Call Received' $file | cut -d: -f 2-4 | cut -dT -f1 | { read input; date +%Y%m%d%H%M -d "$input"; })

  # set new timestamp to incident creation time
  touch $file -t "$new_time"

  # copy pdf file to times folder
  cp -a $file /mnt/local_share/$filename
  #cp -a $file /home/pi/$filename

  # remove original pdf file
  rm $file

  # remove extra files from email
  rm part* file.txt

  # remove original email
  rm $i

  # print time for log
  echo $(date)
  echo "***********************"
done
