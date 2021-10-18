# Documentation

**May be out of date, as this is a development version.**

## How to use

Start the addon and use Ingress for initial configuration.

For external access you can setup another user, or change the password of the user `homeassistant`.

## Configuration

### Network

By default there is access through Ingress, but no ports are exposed outside of Home Assistant. To have external access, for instance to a slicer, you either need to specify a port or setup a proxy.

### Slicer

To connect an external slicer such as Cura to OctoPrint you need to expose the WebUI port. It is **not** possible through Ingress.

### Credentials

One user, `homeassistant`, is created with a random password on first launch. You can use Ingress to automatically sign in as this user. From there you can change password, or create another user. Note that if the user `homeassistant` is removed, it will be recreated on the next restart.

### Updates

First make a backup, from within OctoPrint.
Updates of OctoPrint should be possible from inside the addon.
