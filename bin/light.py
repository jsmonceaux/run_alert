#!/usr/bin/env python2

import RPi.GPIO as GPIO
import time

pin = int(14)
delay = int(90)

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(pin, GPIO.OUT)

print "light on"
GPIO.output(pin, GPIO.HIGH)
time.sleep(delay)
print "light off"
GPIO.output(pin, GPIO.LOW)

