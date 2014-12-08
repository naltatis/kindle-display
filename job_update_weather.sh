#!/bin/sh
cd /home/pi/kindle-display/;/home/pi/phantomjs/bin/phantomjs screenshot.js;/usr/bin/pngcrush -c 0 public/weather.png public/weather_bw.png
