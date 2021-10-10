#!/usr/bin/with-contenv bashio

bashio::log.info "proxy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%ingress_entry%%#$(bashio::addon.ingress_entry)#g" /etc/caddy/Caddyfile
# sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
# sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/tinyproxy/tinyproxy-ingress.conf
# sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/nginx.conf

if bashio::config.true 'recovery'; then
    sed -i "s%#insert_rescue%rewrite / /recovery%g" /etc/caddy/Caddyfile
fi