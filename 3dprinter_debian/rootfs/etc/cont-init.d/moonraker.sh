#!/usr/bin/with-contenv bashio

bashio::log.info "Moonraker cont-init.d"

if bashio::config.true 'moonraker'; then
    # Copy Moonraker install to persistent storage, if missing.
    if [ ! -d /data/python/moonraker ]; then
        if [ -f /root/moonraker-python.tar.gz ]; then
            tar -zxf /root/moonraker-python.tar.gz -C /data
            bashio::log.notice "Moonraker Python extracted"
        else
            bashio::log.warning "Moonraker Python archive not found"
        fi
    fi

    # Copy source to persistent storage, if missing.
    if [ ! -d /data/src/moonraker ]; then
        if [ -f /root/moonraker-src.tar.gz ]; then
            tar -zxf /root/moonraker-src.tar.gz -C /data
            bashio::log.notice "Moonraker src extracted"
        else
            bashio::log.warning "Moonraker src not found"
        fi
    fi

    # Test install
    { # try
        bashio::log.notice "Verify that Moonraker can be called"
        MOONRAKER_PYTHON=/data/python/moonraker/bin/python
        MOONRAKER=/data/src/moonraker/moonraker/moonraker.py
        ${MOONRAKER_PYTHON} ${MOONRAKER} -h
    } || { # catch
        bashio::log.warning "Moonraker help command failed."
        if [ ! -f /data/python/moonraker/REPAIRED_$(bashio::addon.version) ]; then
            bashio::log.notice "Attempt pip reinstall, this may take a while!"
            source /data/python/moonraker/bin/activate
            pip freeze > /tmp/pip_freeze_moonraker
            pip install --force-reinstall -r /tmp/pip_freeze_moonraker
            deactivate
            touch /data/python/moonraker/REPAIRED_$(bashio::addon.version)
            bashio::log.notice "Re-install completed."
        else
            bahsio::log.error "Repair previously attempted, won't try again."
        fi
    }

    # Make sure log file exists
    touch /tmp/moonraker.log

    # Configure autostart of service
    rm -f /etc/services.d/moonraker/down
    rm -f /etc/services.d/moonraker/finish
else
    bashio::log.notice "Moonraker disabled"
fi
