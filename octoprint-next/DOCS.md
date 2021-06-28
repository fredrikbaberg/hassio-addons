# Documentation

## How to use

Start the addon and use Ingress for initial configuration.

For external access you can setup another user, or change the password of the user `homeassistant`.

## Configuration

Under `options` there is a toggle to force recovery mode. To leave this mode and return to the normal interface you need to disable the toggle and completely shutdown the addon before starting it again.

### Network

By default there is access through Ingress, but no ports are exposed outside of Home Assistant. To have external access, for instance to a slicer, you either need to specify a port or setup a proxy.

### Slicer

No slicer included.

To connect an external slicer, such as Cura, to OctoPrint you need to expose the WebUI port. It is not possible through Ingress.

### Credentials

One user, `homeassistant`, is created with a random password on first launch. You can use Ingress to automatically sign in as this user. From there you can change password, or create another user. Note that if the user `homeassistant` is removed, it will be recreated on the next restart.

### Updates

First make a backup, from within OctoPrint.
Updates of OctoPrint should be possible from inside the addon.

### Camera

`mjpg-streamer` is included, but needs to be started manually through the power menu. Note that video does not work from within Ingress, you need to either expose the port for mjpg-streamer or use a reverse proxy. 

### Q and A

- I have multiple devices connected, ttyUSB0 may not be my printer?
  - Connect by device ID instead. In Home Assistant this can be found under "Supervisor" - "System" - "Hardware" `/dev/serial/by-id/usb-...`
- The camera stream is not visible?
  - Are you using Ingress for access? Try through WebUI (set port in configuration).
    - If you have ideas how to configure reverse proxy to get the camera stream through Ingress, please let me know.
  - Did you start the camera? This has to be done manually, see previous section.
- How do I reset addon/OctoPrint data?
  - Uninstall and (re)install the addon to reset plugins etc.
- `<plugin>` fails to install?
  - Some dependencies may be missing. Check the log and create an issue on the GitHub repo or in the thread on the community.
- How can I access GPIO?
  - Find a suitable plugin for OctoPrint.
  - Make sure not to use the same GPIO in Home Assistant or another addon.

## Versions

Some notes regarding the software and versions.
Not all software is installed for all images.

- OctoPrint
  - Installed in a `virtualenv` from PyPI, using latest version available when image was built.

- mjpg-streamer
  - Compiled from master branch of [https://github.com/jacksonliam/mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer).
