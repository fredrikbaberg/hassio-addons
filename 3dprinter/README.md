# 3DPrinter add-on for Home Assistant

**Note: There is an issue with 32-bit installs, see notes below.**

## About

This add-on allows you to connect to and control your 3D printer on a device running [Home Assistant](https://home-assistant.io/).
It contains:
- [OctoPrint](https://octoprint.org)
- [mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer)
- [gphoto2](http://gphoto.org/)
- [Klipper](https://www.klipper3d.org/)
- [Moonraker](https://moonraker.readthedocs.io/)

## Installation

Add the repository [https://github.com/fredrikbaberg/hassio-addons](https://github.com/fredrikbaberg/hassio-addons) in Home Assistant, see [https://www.home-assistant.io/hassio/installing_third_party_addons/](https://www.home-assistant.io/hassio/installing_third_party_addons/).

## Documentation

See the tab _Documentation_ in Home Assistant addon page, or the file `DOCS.md`.

## 32-bit installs

If you are running a 32-bit install of Home Assistant OS (`armv7`) the default virtual environment is broken. The current options are to disable architecture `armv7` or implement a workaround, for now the workaround is in place. This reinstalls all packages in the Python virtual environment, however, this will take a lot of time.

## Support

Create an issue on [GitHub](https://github.com/fredrikbaberg/hassio-addons), don't forget to specify which addon and version you are using.
There is also a thread on [Home-Assistant community](https://community.home-assistant.io/t/repository-octoprint-wip/22883).
