#!/usr/bin/with-contenv bashio

echo "Update Klipper source to latest version (git master branch)"

cd /data/klipper
# Stash changes
git stash
# Update from repository
git checkout master
git pull
# git pull origin master
# # Apply fix for scheduler
# sed -i 's"// sched_main"// sched_main\n#include <pthread.h>"' /data/klipper/src/linux/main.c
# sed -i 's/sched_setscheduler(0/pthread_setschedparam(pthread_self()/' /data/klipper/src/linux/main.c
# # Make, install and clean
# make clean
# make
# ./scripts/flash-linux.sh
# make clean
