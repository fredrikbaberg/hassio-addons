#!/usr/bin/with-contenv bashio

bashio::log.info "Proxy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)

sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /data/proxy/haproxy.cfg

# if bashio::config.true 'recovery'; then
#     sed -i "s%#recovery%rewrite / /recovery%g" /etc/caddy/Caddyfile
# fi
