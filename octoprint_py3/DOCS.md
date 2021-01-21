# Documentation

## Configuration

Configuration should only be needed for camera support.

- `mjpg_input`: Specify input arguments for mjpg_streamer.
- `mjpg_output`: Specify output arguments for mjpg_streamer.

### Network

Two ports can be specified, both are disabled by default.

- WebUI: Used to connect to OctoPrint outside of Ingress. E.g. have a slicer connect to OctoPrint.
- mjpg-streamer: Port for mjpg-streamer to be externally available.


## How to use

Start the addon. First setup assumes Ingress is used.
There is a default user (`homeassistant`) used for Ingress, the password is randomly generated on first launch. If this user is removed it will be re-created on next restart.

If you need external access (e.g. connect from a slicer such as Cura) you need to set a port for WebUI (disabled by default). In case you need access outside of Ingress, feel free to change the password of user `homeassistant` or create a new user.

OctoPrint config is stored in `config/octoprint` folder, however, plugins are not. If you reinstall the addon plugins will be lost (unless you use a backup).

### Slicer

CuraEngine Legacy is installed, in case you need to slice from within OctoPrint. A plugin is needed to use this, see [OctoPrint CuraLegacy plugin](https://plugins.octoprint.org/plugins/curalegacy/).

### Credentials

Through Ingress no password should be required. The initial password for user `homeassistant` is randomly generated, access OctoPrint through Ingress in order to create a new user or set a new password.

### Updates

Make sure to make a backup before updating. Backup can be created from within OctoPrint WebUI.

### Camera

Basic camera support should now be in place. Snapshots should work without opening any port. Video stream requires at least one of the two ports enabled (5000/`WebUI` or 8000/`mjpg-streamer`).
Some additional configuration may be needed, the following excerpt from `config.yaml` may be helpful:

```
webcam:
    ffmpeg: /usr/bin/ffmpeg
    snapshot: http://localhost:8080/?action=snapshot
    stream: http://<device IP address>:5000/webcam/?action=stream
```

### Q and A

- `pip` not found?
  - Try to refresh the page, or restart the Add-On.
- I have multiple devices, ttyUSB0 is not always the correct device?
  - Use device ID instead. In Home Assistant this can be found under "Supervisor" - "System" - "Hardware" `/dev/serial/by-id/usb-...`
- Camera stream is not visible?
  - Is `mjpg-streamer` running? It can be started from OctoPrint UI, same menu as for stop and restart.
  - Are you accessing through Ingress? Try through WebUI (set port in configuration).
- How do I reset data?
  - Delete the folder `config/octoprint_py3` to reset OctoPrint settings.
  - Uninstall and (re)install the addon.
- How do I get Raspberry Pi camera to work in Home Assistant?
  - Probably not officially supported, but based on [https://raspberrypi.stackexchange.com/a/51440](https://raspberrypi.stackexchange.com/a/51440) I did the steps related to `start_x.elf` and `fixup_x.dat`. Note that I skipped the `modprobe` and `v4l2-ctl` parts. Note that an update of `HassOS` requires you to re-download the files for the system to boot again.
- I cannot install <plugin>?
  - Build dependencies are included in this version, create an issue on GitHub if it does not work.
- How do I autostart the camera?
  - To start the camera with the addon you can use [event hooks](https://docs.octoprint.org/en/master/events/index.html). Add the following lines to `config.yaml`:
    ```
    events:
    enabled: true
    subscriptions:
    -   command: supervisorctl start mjpg-streamer
        enabled: true
        event: Startup
        type: system
    ```

## Versions

Some notes regarding the software and versions.
Not all software is installed for all images.

- OctoPrint
Installed in a `venv` from PyPI.

- CuraEngine
A legacy version of CuraEngine is required to use Cura as slicer from within OctoPrint, for more information see [OctoPrint CuraLegacy plugin](https://plugins.octoprint.org/plugins/curalegacy/).

- PyBonjour
Not available from PyPI, so installed from external source. Port configuration probably prevents discovery.

- mjpg-streamer
Compiled from [https://github.com/jacksonliam/mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer).
