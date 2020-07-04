# Changelog

[0.3.0-beta-6]

Changes:
- Initial webcam support (video stream requires specifying port)
- Add option to only expose mjpg-streamer
- Copy config.yaml instead of generate
- mjpg-streamer input_raspicam removed
- Modified CuraEngine build (internal change)
- Only output stdout log files

[0.3.0-beta-5]

Changes:
- Add mjpg-streamer to supervisord
- Add system access to camera
- Add both UVC and raspicam options to mjpg-streamer
- Output all logs, not just octoprint

[0.3.0-beta-3]

Changes:
- Revert to supervisor installed through apk (did not restart properly otherwise)

[0.3.0-beta-2]

Changes:
- Install supervisor with pip (avoid two versions of Python)
- Compress files, should reduce image size

[0.3.0-beta-1]

Preparation to use this as main version from now on.

Changes:
- Remove `experimental` flag and from config directory
- Install `zlib` by default

Breaking changes on update:
- Config folder was renamed (removed `_experimental`). To fix this:
  - Rename folder from `octoprint_experimental` to `octoprint`
  - Replace `octoprint_experimental` with `octoprint` in config file (`octoprint/config.yaml`)

[0.3.0-beta-0]

Same as previous alpha, just to indicate that this is what I intend to use as release.
Please report any errors, since this may replace both `Dev` and `Slim`.

[0.3.0-alpha-10]

Lot of changes for this release, you may need to uninstall and reinstall for this to work. Unfortunately I discovered an error with previous backups, they contain lots of extra data due to a configuration error (wrong baseDir used) and may not be useable.

- Backup and Restore should now work (previous backups were broken!)
- Revert to Python2
- Separate config directory `octoprint_experimental`
- Move baseDir to config folder
- Add option to reset data folder
- `Start on boot` now default manual instead of auto
- Cleaned up initial config (e.g. unused mjpg-streaming config)
- Add shutdown and restart command (for OctoPrint)
- Correction to restart OctoPrint command, should no longer halt Add-on log
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
