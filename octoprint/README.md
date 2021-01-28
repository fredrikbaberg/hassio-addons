# OctoPrint add-on for Home Assistant

**Ensure you have a backup of your configuration.**

## About

This Addon-on allows you to run [OctoPrint](https://octoprint.org) on a device running [Home Assistant](https://home-assistant.io/).

## Installation

Add the repository [https://github.com/fredrikbaberg/hassio-addons](https://github.com/fredrikbaberg/hassio-addons) in Home Assistant, see [https://www.home-assistant.io/hassio/installing_third_party_addons/](https://www.home-assistant.io/hassio/installing_third_party_addons/).

## Documentation

See the tab _Documentation_ or the file `DOCS.md`.

## Support

Either write in the [thread](https://community.home-assistant.io/t/repository-octoprint-wip/22883) or create an issue on [GitHub](https://github.com/fredrikbaberg/hassio-addons).

## Development

For local debugging, use the following command: `docker build . -t local/octoprint ; docker run --rm -it -p 5000:5000 -v ${pwd}/octoprint_config:/config -v octoprint_data:/data --entrypoint=/bin/bash local/octoprint`
