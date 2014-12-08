#!/bin/sh

cd "$(dirname "$0")"

# powering up networking again
lipc-set-prop com.lab126.cmd wirelessEnable 1
/etc/init.d/wifid start
sleep 15

rm weather_bw.png
#eips -c

if wget http://192.168.31.41:3000/weather_bw.png; then
  eips -f -g weather_bw.png
  # display battery level
  eips 48 0 "`lipc-get-prop com.lab126.powerd battLevel`"
else
  # server not available
  eips 0 0 "retry"
fi

# low battery
if [ `lipc-get-prop com.lab126.powerd battLevel` -le 25 ]; then
  eips 0 0 "________________________________________________"
  eips 0 1 "--------------------------------------------------"
fi

# powering down networking
lipc-set-prop com.lab126.cmd wirelessEnable 0
/etc/init.d/wifid stop
