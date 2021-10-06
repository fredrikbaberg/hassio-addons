#!/usr/bin/with-contenv bashio

bashio::log.warning "Restart OctoPrint."

s6-svc -r /var/run/s6/services/octoprint

# Restart the entire addon instead of only OctoPrint for now. Should use s6 later.
# bashio::addon.restart

# /bin/s6-svc -wD -d /var/run/s6/services/octoprint
# sleep 5
# /bin/s6-svc -wU -u /var/run/s6/services/octoprint
