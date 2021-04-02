# Documentation

## Configuration

- `config_folder_suffix`: Suffix for config folder, will be `/config/octoprint<config_folder_suffix>`.

### Network

By default no port is exposed outside of Home Assistant. You need to either set a port, or use a proxy, to have access to OctoPrint from e.g. a slicer.

## How to use

Start the addon. First setup assumes Ingress is used.
There is a default user (`homeassistant`) used for Ingress, the password is randomly generated on first launch. If this user is removed it will be re-created on next restart.

If you need external access, e.g. for a slicer such as Cura, you need to specify a port for WebUI. In case you need access outside of Ingress, feel free to change the password of user `homeassistant` or create a new user.

OctoPrint config is stored in `config/octoprint<config_folder_suffix>` folder, however, plugins are not. If you reinstall any plugins will be lost.

### Slicer

No slicer included.

### Credentials

One user, `homeassistant`, is created with a random password on first launch. Use Ingress to change password or setup another user.

### Updates

Backup first, from within OctoPrint. It should be possible to update from within OctoPrint.

### Camera

mjpg-streamer is available as a separate add-on to provide camera support.

You may find the following excerpt from `config.yaml` helpful:

```
webcam:
    ffmpeg: /usr/bin/ffmpeg
    stream: http://local-mjpg-streamer:8000/?action=stream
    snapshot: http://local-mjpg-streamer:8000/?action=snapshot
```

With the camera provided by another add-on, you need to control that add-on to start and stop the camera.

### Q and A

- `pip` is not found?
  - Try to refresh the page, or restart the Add-On.
- I have multiple devices, what if ttyUSB0 is not the correct device?
  - Use device ID instead. In Home Assistant this can be found under "Supervisor" - "System" - "Hardware" `/dev/serial/by-id/usb-...`
- Camera stream is not visible?
  - Is `mjpg-streamer` running? It can be started from OctoPrint UI, same menu as for stop and restart.
  - Are you accessing through Ingress? Try through WebUI (set port in configuration).
- How do I reset addon/OctoPrint data?
  - Rename or remove folder `config/octoprint<config_folder_suffix>`,
  - Uninstall and (re)install the addon.
- How do I get Raspberry Pi camera to work in Home Assistant?
  - On your own risk, based on [https://raspberrypi.stackexchange.com/a/51440](https://raspberrypi.stackexchange.com/a/51440), I did the steps related to `start_x.elf` and `fixup_x.dat`. Note that I skipped the `modprobe` and `v4l2-ctl` parts. Updates to `HassOS` will break the system, you will need to download the files again for the system to boot.
- `<plugin>` fails to install?
  - Some dependencies may be missing. There are no additional build tools included in this version.
- How can I access GPIO?
  - This is currently missing. It may be enough to setup AppArmor, please let me know if you have knowledge on this.
- I get a `Load failed` on access through Ingress?
  - It seems `CORS` is required if you use `https`. This can be done from OctoPrint or with the following line in `config.yaml`:
    ```
    api:
      allowCrossOrigin: true
    ```
  - If you know how to setup `haproxy` to avoid this, please let me know.

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
