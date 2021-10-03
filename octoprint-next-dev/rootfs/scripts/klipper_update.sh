#!/usr/bin/with-contenv bashio

echo "Update Klipper to latest version"

cd /data/klipper
git pull origin master
