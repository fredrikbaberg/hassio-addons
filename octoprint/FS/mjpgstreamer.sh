#!/usr/bin/with-contenv bashio

exec mjpg_streamer -i \"$(bashio::config 'mjpg_input')\" -o \"=$(bashio::config 'mjpg_output')\"