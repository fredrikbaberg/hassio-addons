#!/bin/bash
# Build a Docker image and test to launch it (replacing the entrypoint with /bin/sh). For testing.
export DEV_VIDEO=/dev/null
mkdir -p my_test_data && mkdir -p my_test_config
sudo docker build . --build-arg BUILD_FROM="homeassistant/amd64-base:latest" -t local/octoprint_experimental
sudo docker run -it --rm -v $(pwd)/my_test_data:/data -v $(pwd)/my_test_config:/config -p 8099:8099 -p 8090:8090 --device=$DEV_VIDEO:/dev/video0 --entrypoint /bin/sh local/octoprint_experimental
# docker run --rm --privileged -v ~/.docker:/root/.docker homeassistant/amd64-builder --all -t octoprint -r https://github.com/fredrikbaberg/hassio-addons -b build_update
