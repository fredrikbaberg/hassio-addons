#!/bin/sh
set -e

echo "Convert run.sh from bashio to (ba)sh compatible, for debugging"

dos2unix /run.sh

# Replace bashio and other commands for development environment
sed -i "s#/usr/bin/with-contenv bashio#/bin/sh#g" /run.sh
sed -i "s#bashio::log.info#echo#g" /run.sh
sed -i "s#bashio::config.true '#[[ -e /data/#g;s#';# ]];#g" /run.sh
sed -e '/ingress_entry=$(bashio::addon.ingress_entry)/s/^/#/g' -i /run.sh
sed -e '/sed -i "s#%%base_path%%#${ingress_entry}#g"/s/^/#/g' -i /run.sh
sed -i "s#\$(bashio::config 'mjpg_input')#'input_file.so -f /www_mjpg -e'#g" /run.sh
sed -i "s#\$(bashio::config 'mjpg_output')#'output_http.so -w /www_mjpg -p 8080'#g" /run.sh
sed -i "s@# sed -e '/http-request@sed -e '/http-request@g" /run.sh

/run.sh