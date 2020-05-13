docker run --rm --privileged -v ~/.docker:/root/.docker -v /var/run/docker.sock:/var/run/docker.sock:ro -v ${pwd}/$@:/data -e DOCKER_BUILDKIT=1 homeassistant/amd64-builder --all -t /data --no-crossbuild-cleanup

# docker run --rm --privileged -v ${pwd}/octoprint:/data -e DOCKER_BUILDKIT=1 homeassistant/amd64-builder --all -t /data --no-crossbuild-cleanup