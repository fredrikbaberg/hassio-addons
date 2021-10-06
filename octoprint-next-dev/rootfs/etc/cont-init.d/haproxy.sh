#!/usr/bin/with-contenv bashio

bashio::log.info "HAProxy cont-init.d"

sed -i "s#%%ingress_entry%%#${bashio::addon.ingress_entry}#g" /etc/haproxy/haproxy.cfg
