# Documentation

**May be out of date, as this is a development version.**

## How to use

Start the addon and use Ingress for initial configuration.

For external access you can setup another user, or change the password of the user `homeassistant`.

## Configuration

### Network

By default there is access through Ingress, but no ports are exposed outside of Home Assistant. To have external access, for instance to a slicer, you either need to specify a port or setup a proxy.

### Slicer

To connect an external slicer, such as Cura, to OctoPrint you need to expose the WebUI port. It is not possible through Ingress.

Two slicers are available with the addon, CuraEngine 15.04.6 and Slic3r 1.3.0. The path should already be set in the initial config file, but are also stated here:
- CuraEngine: `/usr/local/bin/CuraEngine`
- Slic3r: `/usr/bin/slic3r`

### Credentials

One user, `homeassistant`, is created with a random password on first launch. You can use Ingress to automatically sign in as this user. From there you can change password, or create another user. Note that if the user `homeassistant` is removed, it will be recreated on the next restart.

### Updates

First make a backup, from within OctoPrint.
Updates of OctoPrint should be possible from inside the addon.

### Camera

`mjpg-streamer` is included, but needs to be started manually through the power menu. Note that video does not work from within Ingress, you need to either expose the port for mjpg-streamer or use a reverse proxy.

If you want to use OctoLapse with a DSLR, `gphoto2` is preinstalled and a script to capture images is available in `/scripts/take_snapshot.sh`. Some additional configuration could be needed.

### Q and A

- I have multiple devices connected, ttyUSB0 may not be my printer?
  - Connect by device ID instead. In Home Assistant this can be found under "Supervisor" - "System" - "Hardware" `/dev/serial/by-id/usb-...`
- The camera stream is not visible?
  - Did you start the camera? This has to be done manually, see previous section.
  - Are you using Ingress for access? Try through WebUI (set port in configuration).
    - If you have ideas how to configure reverse proxy to get the camera stream through Ingress, please let me know.
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

- Klipper
  - Installed in a separate `virtualenv`, using branch `master` from GitHub.

- CuraEngine
  - CuraEngine 15.04.6, works with the plugin CuraEngine Legacy.
- Slic3r
  - Slic3r 1.3.0, installed from APT.
- gphoto2
  - Installed with APT
