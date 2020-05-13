# Changelog

[0.3.0-alpha-10]
Lot of changes for this release, you may need to uninstall and reinstall for this to work. Unfortunately I discovered an error with previous backups, they contain lots of extra data due to a configuration error (wrong baseDir used) and may not be useable.

- Backup and Restore should now work (previous backups were broken!)
- Revert to Python2
- Separate config directory `octoprint_experimental`
- Move baseDir to config folder
- Add option to reset data folder
- `Start on boot` now default manual instead of auto
- Cleaned up initial config (e.g. unused mjpg-streaming config)
- Enable cache on HAproxy (may or may not help)
- Refactor Dockerfile

[0.3.0-alpha-6]
- Include psycopg2 (for filamentmanager)

[0.3.0-alpha-4]
- Switch to Python3

[0.3.0-alpha-1]
- Bugfix for Ingress for normal (experimental) version

[0.3.0-alpha]
- Support for Ingress
- Rewritten install, using pip
- Only OctoPrint (no mjpeg, Cura, etc) for now

[0.2.7]
- Works with HassOS
- Bonjour enabled
- Ready for camera support

[0.2.6]
- Corrections to work with newer version of Hass.IO.
- Should allow other USB devices than ttyUSB0
