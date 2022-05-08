#!/usr/bin/with-contenv bashio

bashio::log.info "Proxy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)
export ingress_entry=${ingress_entry}

ls -lah /etc/caddy

tempio \
    -conf /data/options.json \
    -template /usr/share/tempio/Caddyfile \
    -out /etc/caddy/Caddyfile
