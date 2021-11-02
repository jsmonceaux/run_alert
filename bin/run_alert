#!/bin/bash

#play -n synth 4.0 sin 600 &
play -q /home/pi/sounds/leroy.swf.mp3 &> /dev/null &

bash /home/pi/bin/monitor.sh > /dev/null &

timeout --foreground 1 cat > /home/pi/last_call

base64 -d /home/pi/last_call | pandoc -f html -t markdown | grep -v '^\\\|^!' > /home/pi/last_call.txt &

python /home/pi/bin/light.py > /dev/null &

