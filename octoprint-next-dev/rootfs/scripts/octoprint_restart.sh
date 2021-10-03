#!/usr/bin/with-contenv bashio

echo "Attempt to restart OctoPrint"

# /bin/s6-svc -wU -u /var/run/s6/services/octoprint
/bin/s6-svc -wd -d /var/run/s6/services/octoprint