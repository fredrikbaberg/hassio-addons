#!/usr/bin/with-contenv bashio
# export LD_LIBRARY_PATH=/usr/local/lib
exec mjpg_streamer -i \"$(bashio::config 'mjpg_input')\" -o \"$(bashio::config 'mjpg_output')\"