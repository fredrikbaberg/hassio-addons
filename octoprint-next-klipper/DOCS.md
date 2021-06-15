# Documentation

## How to use

Start the addon and use Ingress for initial configuration.

For external access you can setup another user, or change the password of the user `homeassistant`.

## Configuration

There is a toggle under options to force recovery mode. You may need to shutdown and then start the addon to return to the normal interface.

### Network

By default there is access through Ingress, but no ports are exposed outside of Home Assistant. To have external access, for instance to a slicer, you either need to specify a port or setup a proxy.

### Slicer

No slicer included.

### Credentials

One user, `homeassistant`, is created with a random password on first launch. You can use Ingress to automatically sign in as this user. From there you can change password, or create another user. Note that if the user `homeassistant` is removed, it will be recreated on the next restart.

### Updates

Backup first, from within OctoPrint. It should be possible to update from within OctoPrint.

### Camera

`mjpg-streamer` is included, but needs to be started manually through the power menu. Note that video does not work from within Ingress, you need to either expose the port for mjpg-streamer or use a reverse proxy. 

### Klipper

Klipper is installed in a separate `virtualen` compared to OctoPrint. You can use the path `/root/printer.cfg` for printer config, this is linked to `/data/klipper/printer.cfg` for simplified config.

### Q and A

- I have multiple devices, what if ttyUSB0 is not the correct device?
  - Use device ID instead. In Home Assistant this can be found under "Supervisor" - "System" - "Hardware" `/dev/serial/by-id/usb-...`
- Camera stream is not visible?
  - Camera needs to be provided by another addon.
  - Are you using Ingress for access? Try through WebUI (set port in configuration).
    - If you have ideas how to configure reverse proxy to get the camera stream through Ingress, please let me know.
- How do I reset addon/OctoPrint data?
  - Uninstall and (re)install the addon to reset plugins etc.
- `<plugin>` fails to install?
  - Some dependencies may be missing, check the log and create an issue on the GitHub repo or in the thread on the community.
- How can I access GPIO?
  - Let me know if you have knowledge on AppArmor, I believe proper configuration is what is missing for GPIO support.

## Versions

Some notes regarding the software and versions.
Not all software is installed for all images.

- OctoPrint
  - Installed in a `virtualenv` from PyPI, using latest version.
