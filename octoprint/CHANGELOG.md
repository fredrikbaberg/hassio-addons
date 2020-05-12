# Changelog

[0.3.0-alpha-7]
- Breaking! Previous backups are broken
- Revert to Python2
- Separate config directory for `Experimental`
- Refactor Dockerfile to multistage build
- Backup and restore now working (previously broken!)
- Add option to reset data folder
- `Start on boot` now default manual instead of auto

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
