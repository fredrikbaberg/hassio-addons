#!/usr/bin/with-contenv bashio
# #!/bin/sh
# set -e

# bashio::log.info "run.sh"
# echo "run.sh"
bashio::log.info $(bashio::addon.name)
bashio::log.info $(bashio::addon.version)
bashio::log.info $(bashio::addon.hostname)
bashio::log.info $(bashio::addon.ingress_entry)

## Read values from configuration.
OCTOPRINT_BASEDIR="/config/octoprint"$(bashio::config 'config_folder_suffix')
MJPG_INPUT_ARGS=$(bashio::config 'mjpg_input')
MJPG_OUTPUT_ARGS=$(bashio::config 'mjpg_output')
INGRESS_ENTRY=$(bashio::addon.ingress_entry)
# OCTOPRINT_BASEDIR="/config/octoprint""_dev"
# MJPG_INPUT_ARGS="input_file.so -f /www_mjpg"
# MJPG_OUTPUT_ARGS="output_http.so -w /www_mjpg"
# INGRESS_ENTRY="/"

# Copy system data to persistent location
if [ ! -d /data/python ]; then
    tar -zxf /root/python.tar.gz -C /data/
    rm -rf /root/python.tar.gz
fi

# Create config if it does not exist.
mkdir -p $OCTOPRINT_BASEDIR
if [ ! -f $OCTOPRINT_BASEDIR/config.yaml ]; then
    cp /octoprint/config.yaml $OCTOPRINT_BASEDIR/config.yaml
    sed -i "s#/config/octoprint#$OCTOPRINT_BASEDIR#g" $OCTOPRINT_BASEDIR/config.yaml
fi

# Ensure Ingress user (homeassistant) exist. This should not modify existing users.
new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
octoprint --basedir $OCTOPRINT_BASEDIR user add homeassistant --password $new_password --admin # 2> /dev/null

# Update proxy settings. Use file in OCTOPRINT_BASEDIR if available.
if [ -f /config/${OCTOPRINT_BASEDIR}/haproxy.cfg]; then
    cp /config/${OCTOPRINT_BASEDIR}/haproxy.cfg /etc/haproxy/haproxy.cfg
fi
sed -i "s#%%ingress_entry%%#${INGRESS_ENTRY}#g" /etc/haproxy/haproxy.cfg # Set Ingress entry
# sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg # Only needed for dev

# Update supervisord
sed -i "s+%%basedir%%+${OCTOPRINT_BASEDIR}+g" /etc/supervisord.conf
sed -i "s+%%mjpg_input%%+${MJPG_INPUT_ARGS}+g" /etc/supervisord.conf
sed -i "s+%%mjpg_output%%+${MJPG_OUTPUT_ARGS}+g" /etc/supervisord.conf
sed -i "s+%%password%%+${new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`}+g" /etc/supervisord.conf

# Launch
supervisord -c /etc/supervisord.conf
tail -f /tmp/*
