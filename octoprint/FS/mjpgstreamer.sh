#!/usr/bin/with-contenv bashio
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
exec mjpg_streamer -i \"$(bashio::config 'mjpg_input')\" -o \"=$(bashio::config 'mjpg_output')\"