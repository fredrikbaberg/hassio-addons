#!/bin/sh
set -e
# #!/usr/bin/with-contenv bashio


# echo "run.sh"
echo "run_dev.sh"

rescue(){
    # Simple rescue.
    # - Try to export list of pip packages
    # - Reset Python directory
    # - Try to reinstall pip packages
    #
    # if bashio::config.true 'rescue'; then
        {
            pip freeze --local > /tmp/pipfreeze.txt
        } || {
            # bashio::log.info "Could not save data from pip"
            echo "Could not export list from pip"
        }
        rm -rf /data/python
        tar -zxf /root/python.tar.gz -C /data/
        {
            pip install --upgrade --no-cache-dir -r /tmp/pipfreeze.txt
        } || {
            # bashio::log.info "Could not restore data from pip"
            echo "Could not restore to pip"
        }
    # fi
}

copy_data() {
    if [ ! -d /data/python ]; then
        # bashio::log.info "Copy data to persistent location"
        echo "Copy data to persistent location"
        # cp -R /root/python /data/
        tar -zxf /root/python.tar.gz -C /data/
        rm -rf /root/python.tar.gz
    fi
}

create_ingress_user() {
    # bashio::log.info "Create ingress user"
    echo "Create ingress user"
    new_password=`date +%s | sha256sum | base64 | head -c 32 ; echo`
    octoprint --basedir /config/octoprint user add homeassistant --password $new_password --admin # 2> /dev/null
}

create_config() {
    mkdir -p /config/octoprint
    if [ ! -f /config/octoprint/config.yaml ]; then
        # bashio::log.info "Create config"
        echo "Create config"
        mkdir -p /config/octoprint
        cp /octoprint/config.yaml /config/octoprint/config.yaml
        # cd /octoprint && cp -R * /config/octoprint/
    fi
}

set_ingress_entry() {
    # bashio::log.info "Set Ingress entry"
    echo "Set Ingress entry"
    # ingress_entry=$(bashio::addon.ingress_entry)
    # sed -i "s#%%base_path%%#${ingress_entry}#g" /etc/haproxy/haproxy.cfg
    sed -e '/http-request set-header X-Script-Name/s/^/#/g' -i /etc/haproxy/haproxy.cfg
}

set_mjpg_args(){
    # bashio::log.info "Set mjpg-streamer arguments"
    echo "Set mjpg-streamer arguments"
    INPUT="input_file.so -f /www_mjpg -e"
    OUTPUT="output_http.so -w /www_mjpg -p 8080"
    sed -i "s+%%mjpg_input%%+${INPUT}+g" /mjpgstreamer.sh
    sed -i "s+%%mjpg_output%%+${OUTPUT}+g" /mjpgstreamer.sh
}

# rescue
copy_data
create_config
create_ingress_user # Ensure Ingress user (homeassistant) exist. This should not modify existing users.
set_ingress_entry
set_mjpg_args
# bashio::log.info "Launch"
echo "Launch"
supervisord -c /etc/supervisord.conf
tail -f /tmp/*-stdout*.log