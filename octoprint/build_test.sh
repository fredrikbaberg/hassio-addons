#!/bin/bash
# Build a Docker image and test to launch it (replacing the entrypoint with /bin/sh). For testing.
mkdir -p my_test_data && mkdir -p my_test_config
docker build --build-arg BUILD_FROM="homeassistant/amd64-base:latest" -t local/octoprint_test .
docker run -it --rm -v $(pwd)/my_test_data:/data -v $(pwd)/my_test_config:/config -p 5000 --entrypoint /bin/sh local/octoprint_test
# docker run --rm --privileged -v ~/.docker:/root/.docker homeassistant/amd64-builder --all -t octoprint -r https://github.com/fredrikbaberg/hassio-addons -b build_update
