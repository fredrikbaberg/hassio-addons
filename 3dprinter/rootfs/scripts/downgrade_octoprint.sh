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
<<<<<<< HEAD
    echo "Unable to downgrade OctoPrint version."
=======
    echo "Not able to downgrade OctoPrint."
>>>>>>> 9bda4a649a76c81dd146620e5f335245544de7d2
}