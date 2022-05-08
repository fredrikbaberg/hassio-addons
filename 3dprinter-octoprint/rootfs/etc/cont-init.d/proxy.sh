#!/usr/bin/with-contenv bashio

bashio::log.info "Proxy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)
export ingress_entry=${ingress_entry}

# Make sure output folder exists.
mkdir -p /etc/caddy

tempio \
    -conf /data/options.json \
    -template /usr/share/tempio/Caddyfile \
    -out /etc/caddy/Caddyfile
