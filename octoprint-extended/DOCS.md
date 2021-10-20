# Documentation

**May be out of date or incomplete.**

## How to use

Start the addon and use Ingress for initial configuration.

For external access you can setup another user, or change the password of the user `homeassistant`.

## Configuration

### Network

By default access is available through Ingress. For external access you need to set a port in addon settings.

### Slicer

To connect an external slicer such as Cura to OctoPrint you need to set a port for WebUI in addon settings. It is **not** possible to connect through Ingress.

### Credentials

One user, `homeassistant`, is created with a random password on first launch. This user will automatically be logged in when you access through Ingress. If removed, the account will be recreated on next restart. You are free to change the password, it will not affect access through Ingress.

### Updates

First make a backup, from within OctoPrint.
Updates of OctoPrint should be possible from inside the addon.
