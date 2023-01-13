#!/usr/bin/with-contenv bashio

bashio::log.warning "Check if OctoPrint version should be downgraded"

{
    version="$(octoprint -b /data/config/octoprint --version)"
    # Check if version is available.
    if [[ ! -z $version ]]; then
        if [[ $version == *"1.7"* ]]; then
            echo "Version is OK"
        else
            echo "Need to change version."
            pip install --upgrade OctoPrint==1.7.3
        fi
    else
        echo "Version not available, won't do anything."
    fi
} || {
    echo "Not able to downgrade OctoPrint."
}