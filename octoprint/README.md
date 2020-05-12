# OctoPrint add-on for Home Assistant

**This version is highly experimental! Major changes can occur. `Dev` and `slim` should be more stable.**

**Ensure you have a backup of your configuration.**

This Addon-on allows you to run [OctoPrint](https://octoprint.org) on a device running [Home Assistant](https://home-assistant.io/).

This is the latest version of the addon, I'll try to test changes here before I update other versions. The `Experimental` part of the name was added recently (April 2020), since the previous version was not installable due to change of configuration files. More recent versions of Home Assistant is supported(0.108.0, arbitrary number and mostly a safeguard - I do not plan to work on backwards-compatibility).

This version has been unavailable for some time due to an old configuration, I've been hesitant to update since it could break.
Now there has been some time, so I'll experiment with this version instead of "slim" or "dev". This will be limited to newer versions of Home Assistant (0.108.0 for now, arbitrary number and mostly a safeguard - I do not plan to work on backwards-compatibility but can set a previous version if it can be confirmed to work). Expect breaking changes, and do make a **backup** before updating.

## Setup

* If you are using Ingress (recommended), just start the addon. A default user (`homeassistant`) with a random password is set on first launch. If the user is removed, it will be re-created on next restart.

* If you need external access (e.g. connect from Cura) you need to set a port (default: `null` for disabled).

* OctoPrint config is stored in `config/octoprint` folder, however, plugins and users are stored in persistent folder (should not be accessible for the user). This means plugins will not be kept on re-install.

* CuraEngine Legacy is installed but not the plugin, see [OctoPrint CuraLegacy plugin](https://plugins.octoprint.org/plugins/curalegacy/).

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
Installed in a `venv` from PyPI. The Add-on uses a pre-defined version of OctoPrint (currently 1.4.0 for `Experimental`). However, it should now be possible to update from within OctoPrint.

- CuraEngine
A legacy version of CuraEngine is required to use Cura as slicer from within OctoPrint, [for more information see OctoPrint CuraLegacy plugin](https://plugins.octoprint.org/plugins/curalegacy/).

- PyBonjour
Not available from PyPI, so installed from external source. Port configuration probably prevents discovery.