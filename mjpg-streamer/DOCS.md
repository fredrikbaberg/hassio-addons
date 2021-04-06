# Documentation

## Configuration

- `mjpg_input`: Specify input arguments for mjpg_streamer.

## How to use

Set input arguments through `mjpg_input` configuration option, start the add-on.
The camera stream and snapshot can be accessed by e.g. [MJPEG IP Camera](https://www.home-assistant.io/integrations/mjpeg/) from url `http://<addon-hostname>/?action=stream` or `http://<addon-hostname>/?action=snapshot`.

For testing you can use `input_file.so -f /www_mjpg -e` for `mjpg_input`.

## Versions

Some notes regarding the software and versions.
Not all software is installed for all images.

- mjpg-streamer
  - Compiled from [https://github.com/jacksonliam/mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer).
