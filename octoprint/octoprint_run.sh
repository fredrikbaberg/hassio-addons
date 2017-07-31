#!/bin/sh
# Add this file to somewhere in PATH, to be able to start/stop/restart/status octoprint.
# sudo mkdir -p /config/octoprint
# sudo chown -R octoprint:octoprint /config/octoprint
# if [ ! -f /config/octoprint/config.yaml ]; then
#     cp /home/octoprint/.octoprint/config.yaml /config/octoprint/config.yaml
# fi
# sudo -u octoprint /home/octoprint/OctoPrint/venv/bin/octoprint serve --config /config/octoprint/config.yaml --basedir /config/octoprint

# # sudo -u octoprint /home/octoprint/OctoPrint/venv/bin/octoprint daemon --config /config/octoprint/config.yaml --basedir /config/octoprint $1

# # Kill process, if running.
# kill_process() {
#     if [ -f /home/octoprint/current_octoprint_pid ]; then
#         kill -15 $(cat /home/octoprint/current_octoprint_pid)
#         rm -f /home/octoprint/current_octoprint_pid
#     fi
# }

# # Run octoprint and store ID
# run_octoprint() {
#     sudo -u octoprint /home/octoprint/OctoPrint/venv/bin/octoprint serve --config /config/octoprint/config.yaml --basedir /config/octoprint & echo $! >> /home/octoprint/current_octoprint_pid
# }

# if [ "$1" = "restart" ]; then
#     echo "Restart octoprint"
#     kill_process
#     octoprint start
# elif [ "$1" = "stop" ]; then
#     echo "Stop octoprint"
#     kill_process
# elif [ "$1" = "start" ]; then
#     run_octoprint
# else
#     echo "Missing argument."
# fi
