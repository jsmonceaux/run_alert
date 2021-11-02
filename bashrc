# run watch at login if not ssh
result=$(ps ax | grep grep | awk '{ print $2 }')
if [[ $result == *'tty'* ]]
then
  bash /home/pi/bin/light off; bash /home/pi/bin/display off; watch -t cat /home/pi/last_call.txt
fi
