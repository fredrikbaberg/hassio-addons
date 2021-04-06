# Changelog

[0.4.2]

- Added build packages, will be useful for testing. Could be removed later.

[0.4.0]

- Use s6-overlay instead of supervisord
- Change proxy to Caddy
- Move mjpg-streamer to separate addon

[0.3.6]

- Add zlib

[0.3.5]

- Fix incorrect spacing in run.sh

[0.3.4]

- Correction to haproxy names.

[0.3.3]

- Update proxy configuration.
  - Will use haproxy.cfg from octoprint config directory if available.

[0.3.2]

- Clean up logs
- Remove mjpgstreamer from autostart again

[0.3.1]

- Uses Python3
- Can specify configuration folder suffix
- Supervisord priority set
- Remove CuraEngine-Legacy

[0.2.7]

Added deprecated status for now.

[0.2.7]
- Works with HassOS
- Bonjour enabled
- Ready for camera support

[0.2.6]
- Corrections to work with newer version of Hass.IO.
- Should allow other USB devices than ttyUSB0
