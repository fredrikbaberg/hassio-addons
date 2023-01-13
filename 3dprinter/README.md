# 3DPrinter add-on for Home Assistant

**Note: There is an issue with 32-bit installs, see notes below.**

**Note (2023): This add-on is about to be abandoned due to issues with Ingress, see notice below.**

## **IMPORTANT NOTICE**

A security update prevents Ingress from working if you update to OctoPrint 1.8.x. *This is not something I have been able to fix and it currently does not seem like I will be able to fix it.*

If you upgrade to OctoPrint 1.8.x, you will be locked out from Ingress. Unless you have setup a second user and set a port to access the addon without Ingress, you will not be able to access OctoPrint WebUI.

There is now an experimental option to downgrade OctoPrint to version 1.7.3, in case you get locked out.
This is **ONLY** so that you have a chance to get access to your data again, it should not be seen as a long-term solution.

If you have been locked out of accessing OctoPrint through Ingress, please read through the following instructions to attempt to recover the data:
* Make a backup of the add-on (through Home Assistant OS).
* Upgrade add-on to version 2023.1.0 or newer.
* Under add-on configuration, select `downgrade_octoprint`. This will install attempt to install version 1.7.3.
* When you hopefully have access through Ingress again:
    * Create a user with admin rights.
    * Make a backup of OctoPrint.
* Install newer version of the add-on, see [New repository](https://github.com/fredrikbaberg/ha-3dprinter-addons). Note that this version also doesn't support Ingress.
    * Restore the backup of OctoPrint OR make a clean install.
* Make sure you have all the data you want from this addon before uninstalling it!

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
