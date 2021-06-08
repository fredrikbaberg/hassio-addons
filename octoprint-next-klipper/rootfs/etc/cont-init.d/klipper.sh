#!/usr/bin/with-contenv bashio

bashio::log.info "Prepare Klipper"

mkdir -p /data/klipper/config

touch /data/klipper/config/printer.cfg

touch /tmp/klippy.log
