#!/usr/bin/with-contenv bashio

echo "Update Klipper to latest version"

cd /data/klipper
git pull origin master
make clean
make
./scripts/flash-linux.sh
make clean
