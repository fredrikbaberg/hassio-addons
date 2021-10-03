#!/usr/bin/with-contenv bashio

bashio::log.warning "Terminate OctoPrint."
/bin/s6-svc -wD -d /var/run/s6/services/octoprint
