# Changelog

[0.3.0]

- s6 for most services; OctoPrint still runs under supervisor to reboot properly.
- move scripts to separate folder.
- remove autostart camera option, use events in OctoPrint if needed.

[0.2.0]

- Replace s6 with supervisor
- Add option to set autostart of mjpg-streamer

[0.1.2]

- Add camera start stop actions

[0.1.1]

- Add mjpg-streamer to image

[0.0.12]

- Update configuration options
- Change restart command to reboot

[0.0.11]

- Add delay to start of OctoPrint, to help with restarts
- Camera streamer removed
