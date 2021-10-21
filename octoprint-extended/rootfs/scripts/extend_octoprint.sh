#!/bin/bash

echo "Install additional packages for OctoPrint, e.g. for marlin-binary-protocol."

source /data/python/OctoPrint/bin/activate
pip install ${PIP_FLAGS} cython
pip install ${PIP_FLAGS} \
    marlin-binary-protocol \
    psycopg2
