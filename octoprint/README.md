# OctoPrint add-on for Home Assistant

**Ensure you have a backup of your configuration.**

This Addon-on allows you to run [OctoPrint](https://octoprint.org) on a device running [Home Assistant](https://home-assistant.io/).

## Setup

* If you are using Ingress (recommended), just start the addon. A default user (`homeassistant`) with a random password is set on first launch. If the user is removed, it will be re-created on next restart.

* If you need external access (e.g. connect from Cura) you need to set a port (default: `null` for disabled).

* OctoPrint config is stored in `config/octoprint` folder, however, plugins and users are stored in persistent folder (should not be accessible for the user). This means plugins will not be kept on re-install.

* CuraEngine Legacy is installed but not the plugin, see [OctoPrint CuraLegacy plugin](https://plugins.octoprint.org/plugins/curalegacy/).

* If you see a "pip not found" error, try to reload the page or restart the Add-On.

* When you specify port for your printer, you could use the serial ID instead (`/dev/serial/by-id/...`)

## Credentials

With Ingress no password should be required. A default user called `homeassistant` is created on first launch, and re-created on restart if it has been removed. The password is randomly generated.

If you loose access and need to reset password, there is a configuration option called `reset_password`. Set it to `true` and restart the addon, this should set the credentials to `homeassistant`/`octoprint`. Don´t forget to set this back to `false` and change password!

## Updates

Updates to the addon itself may not work properly, if so make sure to make a backup of OctoPrint and possibly `config/octoprint` directory - delete folder and reinstall addon.
So far no automatic changes to OctoPrint `config.yaml` file are done, if needed remove the file and restart the addon to have it re-created.

## Versions

Some notes regarding the software and versions.
Not all software is installed for all images.

- OctoPrint
Installed in a `venv` from PyPI. The Add-on uses a pre-defined version of OctoPrint (currently 1.4.0). However, it should now be possible to update from within OctoPrint.

- CuraEngine
A legacy version of CuraEngine is required to use Cura as slicer from within OctoPrint, [for more information see OctoPrint CuraLegacy plugin](https://plugins.octoprint.org/plugins/curalegacy/).

- PyBonjour
Not available from PyPI, so installed from external source. Port configuration probably prevents discovery.

## Full reset of data

It is possible to reset the data for the addon without a full reinstall (since the config folder is user-accessible that data is not touched).
To avoid accidental triggering it is not listed under configuration. Add the following to addon `configuration`:
```
request_reset_data: true
```
then restart the addon. Don´t forget to remove that line afterwards - otherwise you will loose the data on each restart.
