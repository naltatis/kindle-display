#!/bin/sh

# saving energy
/etc/init.d/framework stop
#/etc/init.d/powerd stop
lipc-set-prop com.lab126.powerd preventScreenSaver 1

# display image
/mnt/us/display-weather.sh
