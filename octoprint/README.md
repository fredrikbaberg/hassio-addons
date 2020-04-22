# OctoPrint add-on for Home Assistant

**This version is highly experimental!**
**Ensure you have backup of your configuration, the same config folder is used for all versions. Plugins are most likely not kept between updates.**

This version has been unavailabe for some time due to an old configuration. Instead of experimenting with "slim" or "dev" I'm using this. Expect breaking changes, and do keep a **backup** before updating.

## Setup

No configuration is passed through from the options.
First configuration should be done using Ingress, a user is created so no credentials should be needed.
For external access, specify a port and make sure to set a password or create a new user.

## Versions

Some notes regarding the software and versions.
Not all software is installed for all images.

- OctoPrint
Installed in a virtualenv from pypi. It is (most likely) not possible to update OctoPrint version from the add-on. A new image has to be built, this is manually triggered by the developer.

- Cura
Legacy version is needed in order to use Cura as slicer in OctoPrint. There is a plugin in OctoPrint for legacy Cura, which probably has to be installed for this to work.

- PyBonjour
Is not available from pypi, so installed from external source. There has been no investigation as to if discovery works with regards to port configuration.
