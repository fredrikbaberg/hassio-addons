#!/usr/bin/with-contenv bashio

bashio::log.info "HAProxy cont-init.d"

ingress_entry=$(bashio::addon.ingress_entry)
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg

bashio::log.info "Ingress entry: ${ingress_entry}"
