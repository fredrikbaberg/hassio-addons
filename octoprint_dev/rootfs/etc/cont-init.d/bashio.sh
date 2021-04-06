#!/usr/bin/with-contenv bashio

bashio::log.info "Bashio cont-init.d"

bashio::log.info "$(bashio::addon.name)"
bashio::log.info "$(bashio::addon.hostname)"
bashio::log.info "$(bashio::addon.dns)"
bashio::log.info "$(bashio::addon.url)"
bashio::log.info "$(bashio::addon.network)"
bashio::log.info "$(bashio::addon.devices)"
bashio::log.info "$(bashio::addon.ip_address)"
bashio::log.info "$(bashio::addon.ingress)"
bashio::log.info "$(bashio::addon.ingress_entry)"
bashio::log.info "$(bashio::addon.ingress_url)"
bashio::log.info "$(bashio::addon.ingress_port)"
