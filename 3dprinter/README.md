# 3DPrinter add-on for Home Assistant

**Note: There is an issue with 32-bit installs, see notes below.**

## **IMPORTANT NOTICE**

A security update prevents Ingress from working if you update to OctoPrint 1.8.x. There is now an experimental option to downgrade to 1.7.3 in case you get locked out of the addon.
This solution is just for you to have a chance to get access to your data again, it is not a long-term solution.
If you are using this add-on with OctoPrint, please read through the following instructions:
* Select option `downgrade octoprint` in add-on configuration; restart addon.
* When you have access through Ingress:
    * Create a user with admin rights (or update password for user homeassistant).
    * Make a backup of OctoPrint.
* Install other version of the add-on, see [New repository](https://github.com/fredrikbaberg/3dprinter-addons).
    * Either restore the backup of OctoPrint, or make a clean install.

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
