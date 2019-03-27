#!/bin/bash

RAINS=$(curl -s https://weather.yahoo.co.jp/weather/jp/14/4610/14110/******.html | tr '\n' ' ' | sed -e 's/<[^>]*>//g' | grep -oE ' - [0-9].*明日' | tr ' ' '\n' | grep -v '^$' | head -47 | tail -n 8 | awk '{SUM += $1}END{print SUM}')

echo "RAIN="$RAINS

PUMP_TIME=20
if [ $RAINS -gt 10 ]; then
    PUMP_TIME=10
fi

echo "PUMP_TIME="$PUMP_TIME

CAMERA_TIME=$((PUMP_TIME + 10))

ffmpeg -f v4l2 -s 1280x1024 -i /dev/video0 -t 00:00:$CAMERA_TIME -loglevel quiet /home/kaz/camera/$(date +%Y%m%d-%H%M%S).mp4 &
sleep 5
python /home/kaz/water.py $PUMP_TIME
sleep $((PUMP_TIME+5))
