#!/usr/bin/with-contenv bashio

bashio::log.info "Moonraker cont-init.d (not implemented)"

# # Copy Moonraker install to persistent storage, if missing.
# if [ ! -d /data/python/Moonraker ]; then
#     if [ -f /root/Moonraker-python.tar.gz ]; then
#         mkdir -p /data/python
#         tar -zxf /root/Moonraker-python.tar.gz -C /data/python/
#     fi
# fi

# # Copy source to persistent storage, if missing.
# if [ ! -d /data/moonraker ]; then
#     if [ -f /root/Moonraker-src.tar.gz ]; then
#         mkdir -p /data/moonraker
#         tar -zxf /root/Moonraker-src.tar.gz -C /data/
#     fi
# fi

# # Copy config to persistent storage, if missing.
# if [ ! -f /data/config/octoprint/klipper/moonraker.conf ]; then
#     if [ -f /root/config/octoprint/klipper/moonraker.conf ]; then
#         mkdir -p /data/config/octoprint/klipper
#         cp /root/config/octoprint/klipper/moonraker.conf /data/config/octoprint/klipper/moonraker.conf
#     else
#         bashio::log.info "Default Moonraker config not found"
#     fi
# fi

# # Make sure log file exists
# touch /tmp/moonraker.log

# # Configure autostart of service
# if bashio::config.true 'autostart_moonraker'; then
#     rm -f /etc/services.d/moonraker/down
#     rm -f /etc/services.d/moonraker/finish
# else
#     touch /etc/services.d/moonraker/down
#     touch /etc/services.d/moonraker/finish
# fi
