# Changelog

[2022.10.0]

- Fix issues with Ingress after update to 1.8.3 (attempt).
- Update Home Assistant base image.

[2021.11.7]

- Add PIP_FLAGS to final image
- Add repair for Moonraker
- Add script for Moonraker update
- Update script for Klipper update
- Update path for klipper_mcu binary


[2021.11.6]

- Add check to only attempt reinstall once per addon version
- Add repair for Klipper

[2021.11.5]

- Updated OctoPrint startup repair to force reinstall pip packages.

[2021.11.4]

- Change from Docker Hub to ghcr.io.

[2021.11.3]

- Add `py-netifaces` to image

[2021.11.2]

- Add validation for OctoPrint command, with automatic attempt at repair on fail.
- Remove repair option

[2021.11.1]

- Add repair option
- Fix Klipper update script

[2021.11.0]

- Use custom `moonraker.conf` if available
- Update documentation
- Change version number system
