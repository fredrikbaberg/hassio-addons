# Documentation

## Access

There is a default user created called `homeassistant`, this is for access through Ingress. The password is randomized at first launch.

In order to access OctoPrint without Ingress, specify a port in the port section of the addon.

## FAQ

- `pip` is not found?
  - Try to refresh the page, or restart the Add-On.
- I have multiple devices connected, ttyUSB0 is not always the correct device?
  - Try to specify the device ID. In Home Assistant this can be found under "Supervisor" - "System" - "Hardware" `/dev/serial/by-id/usb-...`