# Documentation

All configuration should be done using OctoPrint WebUI.

## Access

There is a default user created called `homeassistant`, this is for access through Ingress. Password is randomized at first boot, but there is a configuration option to reset it to `octoprint` if you need access.

In order to access OctoPrint without Ingress, specify a port in the port section of the addon.