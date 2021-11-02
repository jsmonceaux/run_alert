#!/bin/bash

vcgencmd display_power 1

sleep 90

vcgencmd display_power 0
