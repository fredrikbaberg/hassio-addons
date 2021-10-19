#!/usr/bin/with-contenv bashio

bashio::log.info "Proxy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/http.d/ingress.conf
# sed -i "s/error_log/# error_log/g" /etc/nginx/nginx.conf
# sed -i "s/access_log/# access_log/g" /etc/nginx/nginx.conf

# sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg

# if bashio::config.true 'recovery'; then
#     sed -i "s%#insert_rescue%rewrite / /recovery%g" /etc/caddy/Caddyfile
# fi
