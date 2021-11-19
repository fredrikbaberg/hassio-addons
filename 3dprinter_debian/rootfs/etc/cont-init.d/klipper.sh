#!/usr/bin/with-contenv bashio

bashio::log.info "Klipper cont-init.d"

if bashio::config.true 'klipper'; then
    # Copy Klipper install to persistent storage, if missing.
    if [ ! -d /data/python/klipper ]; then
        if [ -f /root/klipper-python.tar.gz ]; then
            tar -zxf /root/klipper-python.tar.gz -C /data
            bashio::log.notice "Klipper Python extracted"
        else
            bashio::log.warning "Klipper Python not found"
        fi
    fi

    # Copy source to persistent storage, if missing.
    if [ ! -d /data/src/klipper ]; then
        if [ -f /root/klipper-src.tar.gz ]; then
            tar -zxf /root/klipper-src.tar.gz -C /data
            bashio::log.notice "Klipper src extracted"
        else
            bashio::log.warning "Klipper src not found"
        fi
    fi

    # Copy config to persistent storage, if missing.
    if [ ! -f /data/config/klipper/printer.cfg ]; then
        if [ -f /root/config/klipper/printer.cfg ]; then
            mkdir -p /data/config/klipper
            cp /root/config/klipper/printer.cfg /data/config/klipper/printer.cfg
            bashio::log.notice "Default Klipper config copied"
        else
            bashio::log.warning "Default Klipper config not found"
        fi
    fi

    # Test install
    { # try
        bashio::log.notice "Verify that Klipper can be called"
        KLIPPER_PYTHON=/data/python/klipper/bin/python
        KLIPPY=/data/src/klipper/klippy/klippy.py
        ${KLIPPER_PYTHON} ${KLIPPY} -h
    } || { # catch
        bashio::log.warning "Klipper help command failed."
        if [ ! -f /data/python/klipper/REPAIRED_$(bashio::addon.version) ]; then
            bashio::log.notice "Attempt pip reinstall, this may take a while!"
            source /data/python/klipper/bin/activate
            pip freeze > /tmp/pip_freeze_klipper
            pip install --force-reinstall -r /tmp/pip_freeze_klipper
            deactivate
            touch /data/python/klipper/REPAIRED_$(bashio::addon.version)
            bashio::log.notice "Re-install completed."
        else
            bahsio::log.error "Repair previously attempted, won't try again."
        fi
    }

    # Make sure log file exists
    touch /tmp/klippy.log

    # Configure autostart of service
    rm -f /etc/services.d/klipper/down
    rm -f /etc/services.d/klipper/finish
else
    bashio::log.notice "Klipper disabled"
fi
