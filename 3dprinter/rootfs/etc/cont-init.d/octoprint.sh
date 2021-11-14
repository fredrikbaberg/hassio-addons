#!/usr/bin/with-contenv bashio

bashio::log.info "OctoPrint cont-init.d"

if bashio::config.true 'octoprint'; then
    # Copy OctoPrint install to persistent storage, if missing.
    if [ ! -d /data/python/octoprint ]; then
        if [ -f /root/octoprint-python.tar.gz ]; then
            tar -zxf /root/octoprint-python.tar.gz -C /data
            bashio::log.notice "OctoPrint Python extracted"
        else
            bashio::log.warning "OctoPrint Python not found"
        fi
    fi

    # Copy config to persistent storage, if missing.
    if [ ! -f /data/config/octoprint/config.yaml ]; then
        if [ -f /root/config/octoprint/config.yaml ]; then
            mkdir -p /data/config/octoprint
            cp /root/config/octoprint/config.yaml /data/config/octoprint/config.yaml
            bashio::log.notice "Default OctoPrint config copied"
        else
            bashio::log.warning "Default OctoPrint config not found"
        fi
    fi

    { # try
        bashio::log.notice "Verify that OctoPrint can be called"
        octoprint --version
    } || { # catch
        bashio::log.warning "OctoPrint command failed, attempt pip reinstall. This will take a while!"
        pip freeze > /tmp/pip_freeze.txt
        pip install -r /tmp/pip_freeze.txt --force-reinstall
        bashio::log.notice "Re-install completed."
    }

    { # try
        bashio::log.notice "Ensure Ingress user (homeassistant) exist."
        new_password=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
        octoprint --basedir /data/config/octoprint user add homeassistant --password "$new_password" --group users --group admins # 2> /dev/null
    } || { # catch
        bashio::log.warning "Failed to ensure Ingress user exists, may not be able to launch."
    }

    # Configure autostart of service
    rm -f /etc/services.d/octoprint/down
    rm -f /etc/services.d/octoprint/finish
else
    bashio::log.notice "OctoPrint disabled"
fi
