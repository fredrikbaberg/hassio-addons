#!/usr/bin/with-contenv bashio


### Prepare OctoPrint
bashio::log.info "Prepare OctoPrint"

# Copy system data to persistent location, if missing.
if [ ! -d /data/python ]; then
    tar -zxf /root/python.tar.gz -C /data/
    rm -rf /root/python.tar.gz
fi

# Create config if it does not exist.
mkdir -p /data/octoprint
if [ ! -f /data/octoprint/config.yaml ]; then
    cp /octoprint/configuration.yaml /data/octoprint/config.yaml
fi

# Ensure Ingress user (homeassistant) exist.
new_password=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
octoprint --basedir /data/octoprint user add homeassistant --password "$new_password" --admin # 2> /dev/null

### Prepare Caddy
bashio::log.info "Prepare Caddy"

sed -i "s#%%base_path%%#$(bashio::addon.ingress_entry)#g" /etc/caddy/Caddyfile
if bashio::config.true 'recovery'; then
    sed -i "s%#insert_rescue%rewrite / /recovery%g" /etc/caddy/Caddyfile
fi

### Prepare mjpg-streamer
bashio::log.info "Prepare mjpg-streamer"

sed -i "s#%%mjpg_input%%#$(bashio::config 'mjpg_input')#g" /etc/supervisord.conf
sed -i "s#%%autostart_mjpg_streamer%%#$(bashio::config 'autostart_mjpg_streamer')#g" /etc/supervisord.conf

cat /etc/supervisord.conf

### Launch
bashio::log.info "Launch"

supervisord -c /etc/supervisord.conf
tail -f /tmp/*-stdout*.log
