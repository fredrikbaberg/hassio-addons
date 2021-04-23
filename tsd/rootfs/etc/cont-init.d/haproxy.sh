#!/usr/bin/with-contenv bashio

bashio::log.info "Prepare haproxy"


ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
