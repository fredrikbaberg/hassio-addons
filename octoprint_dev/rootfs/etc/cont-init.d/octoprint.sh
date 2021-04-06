#!/usr/bin/with-contenv bashio

bashio::log.info "OctoPrint cont-init.d"

## Read values from configuration.
OCTOPRINT_BASEDIR="/config/octoprint"$(bashio::config 'config_folder_suffix')

# Copy system data to persistent location, if missing.
if [ ! -d /data/python ]; then
    tar -zxf /root/python.tar.gz -C /data/
    rm -rf /root/python.tar.gz
fi

# Create config, if it does not exist.
mkdir -p "$OCTOPRINT_BASEDIR"
if [ ! -f "$OCTOPRINT_BASEDIR"/config.yaml ]; then
    cp /octoprint/configuration.yaml "$OCTOPRINT_BASEDIR"/config.yaml
    sed -i "s#/config/octoprint#$OCTOPRINT_BASEDIR#g" "$OCTOPRINT_BASEDIR"/config.yaml
fi

# Ensure Ingress user (homeassistant) exist. This should not modify existing users.
new_password=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
octoprint --basedir "$OCTOPRINT_BASEDIR" user add homeassistant --password "$new_password" --admin # 2> /dev/null
