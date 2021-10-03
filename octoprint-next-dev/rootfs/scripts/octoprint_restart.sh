#!/usr/bin/with-contenv bashio

bashio::log.warning "Attempt to restart OctoPrint."

/bin/s6-svc -wD -d /var/run/s6/services/octoprint
sleep 5
/bin/s6-svc -wU -u /var/run/s6/services/octoprint

# /bin/s6-svc -wd -d /var/run/s6/services/octoprint
# /bin/s6-svc -r /var/run/s6/services/octoprint
