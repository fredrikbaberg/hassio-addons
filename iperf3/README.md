# iPerf3 add-on for Home Assistant

## About

iPerf3 server running as Home Assistant addon

## Installation

Add the repository [https://github.com/fredrikbaberg/hassio-addons](https://github.com/fredrikbaberg/hassio-addons) in Home Assistant, see [https://www.home-assistant.io/hassio/installing_third_party_addons/](https://www.home-assistant.io/hassio/installing_third_party_addons/).

## Documentation

See the tab _Documentation_ or the file `DOCS.md`.

## Support

Create an issue on [GitHub](https://github.com/fredrikbaberg/hassio-addons).

## Development

For local debugging, use the following command: `docker build . -t local/iperf3 ; docker run --rm -it -p 5201:5201 --entrypoint=/bin/bash local/operf3`