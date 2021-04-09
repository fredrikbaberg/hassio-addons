#!/usr/bin/with-contenv bashio

bashio::log.info "OctoPrint cont-init.d"

# Copy system data to persistent location, if missing.
if [ ! -d /data/python ]; then
    tar -zxf /root/python.tar.gz -C /data/
    rm -rf /root/python.tar.gz
fi

# Create config if it does not exist.
mkdir -p /data/.octoprint
if [ ! -f /data/.octoprint/config.yaml ]; then
    cp /octoprint/configuration.yaml /data/.octoprint/config.yaml
fi

# Ensure Ingress user (homeassistant) exist.
new_password=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
octoprint --basedir /data/.octoprint user add homeassistant --password "$new_password" --admin # 2> /dev/null
