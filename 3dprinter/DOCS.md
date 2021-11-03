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

This addon comes with Klipper pre-installed. *Note that this addon will **not** change the firmware of the printer, that is up to the user*.
To use it with OctoPrint, install the plugin OctoKlipper.

A Linux host process is also available, intended for using a [Raspberry Pi as a secondary MCU](https://www.klipper3d.org/RPi_microcontroller.html). *Not working as intended*.

*Klipper and Moonraker does not seem fully designed to run on Alpine Linux. There may be some modifications in place for it to compile and/or run. Please take this into consideration if you ask for help as it is not a stock install.*

#### Moonraker

Moonraker is pre-installed, for use with e.g. Mainsail or Fluidd (not included).
A `moonraker.conf` is included, to override this place your own file in `/data/config/klipper/moonraker.conf`.

If you want to use Moonraker and Klipper instead of OctoPrint, you can disable `octoprint` in the addon config.

### Updates

Make sure to create a backup first, either using Home Assistant backup option or the backup option from within OctoPrint.
OctoPrint can be updated normally.

### Backups

Backups from within OctoPrint will **only** backup OctoPrint, no configuration of Klipper or Moonraker will be included.
For Klipper and Moonraker configuration you want to use the backup feature of Home Assistant, or copy the files from `/data/config/klipper`.

## Versions

Some notes regarding the software and versions.

- OctoPrint
  - Installed in a `virtualenv` from PyPI, using numbered version (e.g. `1.7.2`) from when image was built.

- mjpg-streamer
  - Compiled from tagged branch of [https://github.com/jacksonliam/mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer), e.g. `v1.0.0`.

- CuraEngine
  - CuraEngine 15.04.6, for use with the plugin CuraEngine Legacy.

- gphoto2
  - Installed through package manager.

- Klipper
  - Installed in a separate `virtualenv`, using branch `master` of [https://github.com/Klipper3d/klipper](https://github.com/Klipper3d/klipper).

- Moonraker
  - Installed in a separate `virtualenv`, using branch `master` from [https://github.com/Arksine/moonraker](https://github.com/Arksine/moonraker).
