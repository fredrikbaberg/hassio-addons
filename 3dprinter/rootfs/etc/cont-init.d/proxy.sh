#!/usr/bin/with-contenv bashio

bashio::log.info "Proxy cont-init.d"

export ingress_entry=$(bashio::addon.ingress_entry)
tempio \
    -conf /data/options.json \
    -template /usr/share/tempio/Caddyfile \
    -out /etc/caddy/Caddyfile
