#!/usr/bin/with-contenv bashio

bashio::log.info "Proxy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)

sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/caddy/Caddyfile

# if bashio::config.true 'recovery'; then
#     sed -i "s%#insert_rescue%rewrite / /recovery%g" /etc/caddy/Caddyfile
# fi
