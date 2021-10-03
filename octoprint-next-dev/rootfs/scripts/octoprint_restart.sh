#!/usr/bin/with-contenv bashio

echo "Attempt to restart OctoPrint"

s6-svc -wD -d -T2500 /var/run/s6/services/octoprint
s6-svc -wU -u -T2500 /var/run/s6/services/octoprint

# /bin/s6-svc -r /var/run/s6/services/octoprint
# /bin/s6-svc -wU -u /var/run/s6/services/octoprint
# /bin/s6-svc -wd -d /var/run/s6/services/octoprint
