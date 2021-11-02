#!/usr/bin/env python2

import RPi.GPIO as GPIO
pin = int(14)
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(pin, GPIO.OUT)
GPIO.output(pin, GPIO.HIGH)

