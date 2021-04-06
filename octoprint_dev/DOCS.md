# Documentation

## How to use

First check configuration of the addon. When ready, start the addon and use Ingress for initial configuration.

For external access you can setup another user, or change the password of the user `homeassistant`.

OctoPrint config is stored in `config/octoprint<config_folder_suffix>` folder, however, plugins are not. If you reinstall any plugins will be lost.

## Configuration

- `config_folder_suffix`: Suffix for config folder, OctoPrint files will be stored in `/config/octoprint<config_folder_suffix>`.

### Network

By default there is access through Ingress, but no ports are exposed outside of Home Assistant. To have external access, for instance to a slicer, you either need to specify a port or setup a proxy.

### Slicer

No slicer included.

### Credentials

One user, `homeassistant`, is created with a random password on first launch. You can use Ingress to automatically sign in as this user. From there you can change password, or create another user. Note that if the user `homeassistant` is removed, it will be recreated on the next restart.

### Updates

Backup first, from within OctoPrint. It should be possible to update from within OctoPrint.

### Camera

mjpg-streamer is available as a separate add-on to provide camera support.

You may find the following excerpt from `config.yaml` helpful:

```
webcam:
    ffmpeg: /usr/bin/ffmpeg
    stream: /webcam/?action=stream
    snapshot: http://local-mjpg-streamer:8000/?action=snapshot
```

As the camera is controlled by another addon, any start and stop of the camera is up to the user.

### Q and A

- `pip` is not found?
  - Try to refresh the page, or restart the Add-On.
- I have multiple devices, what if ttyUSB0 is not the correct device?
  - Use device ID instead. In Home Assistant this can be found under "Supervisor" - "System" - "Hardware" `/dev/serial/by-id/usb-...`
- Camera stream is not visible?
  - Check that `mjpg-streamer` addon is running.
  - Are you accessing through Ingress? Try through WebUI (set port in configuration).
    - If you have ideas how to configure reverse proxy to get the camera stream in Ingress, please let me know. Right now it does not seem to work.
- How do I reset addon/OctoPrint data?
  - Rename or remove folder `config/octoprint<config_folder_suffix>` to remove configuration
  - Uninstall and (re)install the addon to reset plugins etc.
  - Or use OctoPrint recovery mode.
- How do I get Raspberry Pi camera to work in Home Assistant?
  - On your own risk, based on [https://raspberrypi.stackexchange.com/a/51440](https://raspberrypi.stackexchange.com/a/51440), I did the steps related to `start_x.elf` and `fixup_x.dat`. Note that I skipped the `modprobe` and `v4l2-ctl` parts. Updates to `HassOS` will break the system, you will need to download the files again for the system to boot.
- `<plugin>` fails to install?
  - Some dependencies may be missing. There are no additional build tools included in this version.
- How can I access GPIO?
  - This is currently missing. It may be enough to setup AppArmor, please let me know if you have knowledge on this.

## Versions

Some notes regarding the software and versions.
Not all software is installed for all images.

- OctoPrint
  - Installed in a `venv` from PyPI, currently version 1.5.3.

- CuraEngine
  - A legacy version of CuraEngine is required to use Cura as slicer from within OctoPrint, for more information see [OctoPrint CuraLegacy plugin](https://plugins.octoprint.org/plugins/curalegacy/).

- PyBonjour
  - Not available from PyPI, so installed from external source. Port configuration probably prevents discovery.

- mjpg-streamer
  - Compiled from [https://github.com/jacksonliam/mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer).
