#!/usr/bin/with-contenv bashio

# bashio::log.info "Moonraker cont-init.d"

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
