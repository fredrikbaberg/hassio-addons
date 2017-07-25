#!/bin/sh 

# Dependency install 
apk update
apk add --no-cache python yaml-dev py-setuptools
apk add --no-cache --virtual .build \
  git linux-headers gcc libc-dev python-dev py-pip

# Octoprint install
git clone https://github.com/foosel/OctoPrint.git /home/user/octoprint
cd /home/user/octoprint
pip install --upgrade pip
pip install -r requirements.txt --no-cache-dir
python setup.py install
mkdir /home/user/.octoprint

# Cleanup
apk del .build
rm -rf /home/user/octoprint /root/.cache /var/cache/apk/* $0