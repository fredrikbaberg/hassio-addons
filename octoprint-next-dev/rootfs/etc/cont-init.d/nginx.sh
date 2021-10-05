#!/usr/bin/with-contenv bashio

bashio::log.info "nginx cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/nginx/nginx.conf

mkdir -p /var/log/nginx
touch /var/log/nginx/error.log

# sed -i "s#%%base_path%%#$(bashio::addon.ingress_entry)#g" /etc/nginx/http.d/ingress.conf
# if bashio::config.true 'recovery'; then
#     sed -i "s%#insert_rescue%rewrite / /recovery%g" /etc/caddy/Caddyfile
# fi
