#!/usr/bin/with-contenv bashio

bashio::log.warning "Restart OctoPrint."

s6-svc -r /var/run/s6/legacy-services/octoprint
