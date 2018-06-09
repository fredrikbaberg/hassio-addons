#!/bin/bash
# Build a Docker image and test to launch it (replacing the entrypoint with /bin/sh). For testing.
mkdir -p my_test_data && mkdir -p my_test_config
docker build --build-arg BUILD_FROM="homeassistant/amd64-base:latest" -t local/octoprint_test .
# docker run -it --rm -v $(pwd)/my_test_data:/data -v $(pwd)/my_test_config:/config -p 5000 --device=/dev/ttyUSB0:/dev/ttyUSB0:rwm local/octoprint_test
docker run -it --rm -v $(pwd)/my_test_data:/data -v $(pwd)/my_test_config:/config -p 5000 --device=/dev/ttyUSB0:/dev/ttyUSB0:rwm --entrypoint /bin/sh local/octoprint_test
