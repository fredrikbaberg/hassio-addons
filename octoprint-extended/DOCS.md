# Documentation

**May be out of date or incomplete.**

## How to use

Start the addon and use Ingress for initial configuration.

For external access you can setup another user, or change the password of the user `homeassistant`.

## Configuration

### Network

By default access is available through Ingress. For external access you need to set a port in addon settings.

### Slicer

To connect an external slicer such as Cura to OctoPrint you need to set a port for WebUI in addon settings. It is **not** possible to connect through Ingress.

CuraEngine 15.04.6 is pre-installed. To use it, install the plugin [CuraEngine Legacy](https://plugins.octoprint.org/plugins/curalegacy/).

### Camera

mjpg-streamer is available for camera and snapshots. There are issues with the remote proxy and Ingress, to have a video feed you need it to be able outside of Ingress. This is not the case for snapshots, which is pre-configured.
`gphoto2` is also available, for using a [DSLR with OctoLapse](https://github.com/FormerLurker/Octolapse/wiki/V0.4---Configuring-a-DSLR). The script is located at `/scripts/take_snapshot.sh`, note the `_` instead of `-` (dash) in the filename.

### Klipper

Klipper is pre-installed, so that you can install the plugin OctoPrinter and get started *assuming you already have your printer setup for Klipper*. A script is available to get the latest source from GitHub.
There is a Linux host process available, intended for using a [Raspberry Pi as a secondary MCU](https://www.klipper3d.org/RPi_microcontroller.html). **Not tested**

### Credentials

One user, `homeassistant`, is created with a random password on first launch. This user will automatically be logged in when you access through Ingress. If removed, the account will be recreated on next restart. You are free to change the password, it will not affect access through Ingress.

### Updates

First make a backup, from within OctoPrint.
Updates of OctoPrint should be possible from inside the addon.

### Extra dependencies

Some additional `pip` packages may be needed, for instance `marlin-binary-protocol`. Those can be installed through the script "Extend OctoPrint with additional build packages" (`/scripts/extend_octoprint.sh`). They will be installed to persistent storage, so this should only be needed once.