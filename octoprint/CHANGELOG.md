# Changelog

[0.4.0]

Update OctoPrint to version 1.5.3

[0.3.7]

This version should fix issues with recovery.

Changes:
- Modified rescue

[0.3.6]

Changes:
- Skip removal of Python install archive.

[0.3.5]

Changes:
- Capitalization of addon name
- Remove virtual printer from default config
- Update documentation

[0.3.4]

Added configuration parameter `add_build_packages` for install of build tools (`build-base`, `linux-headers`, `python-dev`, `zlib-dev`, `jpeg-dev`), might help to install certain plugins.
Note: any installed package will be lost on restart!

[0.3.3]

Change reset to rescue. Will attempt to reinstall Python with addons.

[0.3.1]

Modify reset option to only delete Python install.
Note: quick fix, should only affect reset script but do be careful. Backup before upgrade, if possible.

[0.3.0]

First _"stable"_ version, other versions of this addon (`dev`, `slim`) are to be considered deprecated.

Changes compared to 0.3.0-beta-0:
- Webcam enabled
- Output not only OctoPrint logs (could help with debugging)
- Compress files, should reduce image size
- `config.yaml` copied instead of generated
- Include `zlib`
- **BREAKING**: Remove `experimental` flag and from config directory

Migrating from `octoprint_experimental`:
- Make a backup
- Stop OctoPrint
- Rename folder in `config/` from `octoprint_experimental` to `octoprint`
- Replace `octoprint_experimental` with `octoprint` in `octoprint/config.yaml`

[0.3.0-beta-0]

Lot of changes for this release, you may need to uninstall and reinstall for this to work. Unfortunately I discovered an error with previous backups, they contain lots of extra data due to a configuration error (wrong baseDir used) and may not be useable.

- Support Ingress
- Backup and Restore should now work (previous backups were broken!)
- Separate config directory `octoprint_experimental`
- Move baseDir to config folder
- Add option to reset data folder
- `Start on boot` now default manual instead of auto
- Cleaned up initial config (e.g. unused mjpg-streaming config)
- Add shutdown and restart command (for OctoPrint)
- Correction to restart OctoPrint command, should no longer halt Add-on log
- Refactor Dockerfile

[0.2.7]
- Works with HassOS
- Bonjour enabled
- Ready for camera support

[0.2.6]
- Corrections to work with newer version of Hass.IO.
- Should allow other USB devices than ttyUSB0
