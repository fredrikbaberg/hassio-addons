#!/usr/bin/with-contenv bashio

iperf3 $(bashio::config 'arguments')
