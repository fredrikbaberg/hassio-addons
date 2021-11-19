#!/usr/bin/with-contenv bashio

echo "Update Klipper to latest version (git master branch)"
export PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"

cd /data/src/klipper
git stash
git checkout master
git pull
git stash pop

# Update Python install
source /data/python/klipper/bin/activate
pip install ${PIP_FLAGS} -r /data/src/klipper/scripts/klippy-requirements.txt
deactivate

# Update klipper_mcu
{
    make clean
    # # Apply fix for scheduler
    # sed -i 's"// sched_main"// sched_main\n#include <pthread.h>"' /data/klipper/src/linux/main.c
    # sed -i 's/sched_setscheduler(0/pthread_setschedparam(pthread_self()/' /data/klipper/src/linux/main.c
    make
    mkdir -p /data/bin
    rm -rf /data/bin/klipper_mcu
    cp out/klipper.elf /data/bin/klipper_mcu
    make clean
} || {
    bashio::log.warning "Failed to update klipper_mcu"
}
