#!/usr/bin/with-contenv bashio

echo "Update Moonraker to latest version (git master branch)"

cd /data/src/moonraker
git stash
git checkout master
git pull
git stash pop

# Update Python install
source /data/python/moonraker/bin/activate
pip install ${PIP_FLAGS} -r /data/src/moonraker/scripts/moonraker-requirements.txt
deactivate
