# Documentation

**May be out of date or incomplete.**

## How to use

Start the addon and use Ingress for initial configuration.

For external access you can setup another user, or change the password of the user `homeassistant`.

## Configuration

### Access and setup

By default access is available through Ingress. For external access you need to set a port in addon settings.

### Credentials

One user, `homeassistant`, is created with a random password on first launch. This user will automatically be logged in when you access through Ingress. If removed, the account will be recreated on next restart. You are free to change the password, this will not affect access through Ingress.

### Camera

mjpg-streamer is available for camera and snapshots. There are issues with the remote proxy and Ingress, to have a video feed you need it to be able outside of Ingress. Snapshots should work with the default configuration.

`gphoto2` is also available, e.g. for using a [DSLR with OctoLapse](https://github.com/FormerLurker/Octolapse/wiki/V0.4---Configuring-a-DSLR). The script is located at `/scripts/take_snapshot.sh`, note the `_` instead of `-` (dash) in the filename.

### Slicer

To connect an external slicer such as Cura to OctoPrint you need to set a port for WebUI in addon settings. It is **not** possible to connect through Ingress.

CuraEngine 15.04.6 is pre-installed. To use it, install the plugin [CuraEngine Legacy](https://plugins.octoprint.org/plugins/curalegacy/).

### Klipper

Klipper is not included.

#### Moonraker

Moonraker is not included.

### Updates

Make sure to create a backup first, either using Home Assistant backup option or the backup option from within OctoPrint.
OctoPrint can be updated normally.

### Backups

Backup of addon will include OctoPrint install. You should also be able to make a backup from within OctoPrint.

### Home Assistant integration

Home Assistant may find the OctoPrint instance, however, it will be discovered with an internal IP address which may not work. To configure the OctoPrint integration on the same Home Assistance instance running this addon use username `homeassistant` and host `774437fd-3dprinter`. Don't forget to approve the request from OctoPrint.

## Versions

Some notes regarding the software and versions.

- OctoPrint
  - Installed in a `virtualenv` from PyPI, using numbered version (e.g. `1.7.3`) from when image was built.

- mjpg-streamer
  - Compiled from tagged branch of [https://github.com/jacksonliam/mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer), e.g. `v1.0.0`.

- CuraEngine
  - CuraEngine 15.04.6, for use with the plugin CuraEngine Legacy.

- gphoto2
  - Installed through package manager.
