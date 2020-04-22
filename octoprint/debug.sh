#!/usr/bin/with-contenv bashio

ingress_enabled=$(bashio::addon.ingress)
ingress_entry=$(bashio::addon.ingress_entry)
ingress_url=$(bashio::addon.ingress_url)
ingress_port="$(bashio::addon.ingress_port)"

bashio::log.info $ingress_enabled
bashio::log.info $ingress_entry
bashio::log.info $ingress_url
bashio::log.info $ingress_port
