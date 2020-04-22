# OctoPrint add-on for Home Assistant

**This version is highly experimental!**
**Ensure you have backup of your configuration, the same config folder is used for all versions. Plugins are most likely not kept between updates.**

This version has been unavailabe for some time due to an old configuration. Instead of experimenting with "slim" or "dev" I'm using this. Expect breaking changes, and do keep a **backup** before updating.

## Setup

No configuration is passed through from the options.
Preferred method is through Ingress, which does not require you to enter credentials.
A default user is created, and will be re-created if removed/renamed, but the password should be changed if you allow external access.
For external access, make sure to set a password and then specify a port.

## Versions

Some notes regarding the software and versions.
Not all software is installed for all images.

- OctoPrint
Installed in a virtualenv from pypi. Image is built with a pre-defined version of OctoPrint, this is set and triggered by the developer. However, it should now be possible to update from within OctoPrint.

- Cura
Legacy version is needed in order to use Cura as slicer in OctoPrint. There is a plugin in OctoPrint for legacy Cura, which probably has to be installed for this to work.

- PyBonjour
Is not available from pypi, so installed from external source. There has been no investigation as to if discovery works with regards to port configuration.
