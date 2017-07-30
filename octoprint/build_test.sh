#!/bin/bash
# Build a Docker image and test to launch it (replacing the entrypoint with /bni/sh). For testing.
# Remember to switch fron %%BASE_IMAGE%% to homeassistant/amd64-base:latest for testing on (modern) PC.
mkdir -p test_data && touch test_data/test_file
mkdir -p test_config && touch test_config/test_file
docker build -t octoprint_test .
docker run -it --rm -v $(pwd)/test_data:/data -v $(pwd)/test_config:/config -p 5000 --entrypoint /bin/sh octoprint_test
# docker run -it --rm -v $(pwd)/test_data:/data -v $(pwd)/test_config:/config -p 5000 octoprint_test
