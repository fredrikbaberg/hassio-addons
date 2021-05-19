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

You have to provide camera feed from another source, for instance the `mjpg-streamer` or `ustreamer` addon.
The following excerpt from `config.yaml` may be helpful, the URL (e.g. `774437fd-ustreamer:80`) can be found for each addon.

```
webcam:
    ffmpeg: /usr/bin/ffmpeg
    stream: /webcam/?action=stream
    snapshot: http://774437fd-ustreamer:80/?action=snapshot
```

Start and stop of the camera is up to the user.

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
