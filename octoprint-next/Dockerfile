ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir"
ENV CFLAGS="-fcommon"
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Install requirements to run
RUN echo "Install base requirements" && \
    apk add --no-cache --virtual .necessary \
        python3 \
        caddy \
        ffmpeg \
        supervisor
RUN echo "Install extras" && \
    apk add --no-cache --virtual .extras \
        build-base \
        linux-headers \
        python3-dev \
        zlib-dev \
        jpeg-dev \
        libjpeg \
        libgphoto2
RUN echo "Install build packages" && \
    apk add --no-cache --virtual .build-dependencies-octoprint \
        py3-virtualenv \
        python3-dev \
        build-base \
        linux-headers && \
    echo "Setup Python" && \
    virtualenv --python=python3 /data/python && \
    source /data/python/bin/activate && \
    pip install ${PIP_FLAGS} --upgrade pip && \
    echo "Install OctoPrint" && \
    pip install ${PIP_FLAGS} \
        OctoPrint \
        zeroconf && \
    echo "Install mjpg-streamer." && \
    # Libraries for Raspberry Pi
    # apk add --no-cache raspberrypi-dev && \
    apk add --no-cache --virtual .build-dependencies-mjpgstreamer \
        make \
        cmake \
        build-base \
        linux-headers \
        libjpeg-turbo-dev \
        libgphoto2-dev && \
    wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz -C /tmp && \
    cd /tmp/mjpg-streamer-master/mjpg-streamer-experimental/ && \
    make --silent && \
    make install --silent && \
    mv www/ /www_mjpg && \
    rm -rf /tmp/mjpg-streamer-master && \
    apk del --no-cache .build-dependencies-mjpgstreamer && \
    # Cleanup, move output
    find /data/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    rm -rf /root/.cache && \
    cd /data && tar -zcf /root/python.tar.gz python && \
    rm -rf /data/python && \
    ## Final cleanup
    apk del --no-cache .build-dependencies-octoprint

# Copy data from filesystem and previous stages
COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /
