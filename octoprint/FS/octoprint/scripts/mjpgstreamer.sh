#!/bin/sh
/usr/local/bin/mjpg_streamer -i "/usr/local/lib/mjpg-streamer/input_uvc.so" -o "/usr/local/lib/mjpg-streamer/output_http.so -w /config/octoprint/www -p 8080"