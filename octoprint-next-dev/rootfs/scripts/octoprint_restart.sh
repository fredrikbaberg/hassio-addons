#!/usr/bin/with-contenv bashio

s6-svc -t /var/run/s6/services/octoprint

# supervisorctl restart octoprint
