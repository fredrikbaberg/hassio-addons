#!/usr/bin/env bashio
set +u

CONFIG_PATH=/data/options.json
ARGUMENTS=$(jq --raw-output ".arguments" $CONFIG_PATH)

iperf3 $ARGUMENTS
