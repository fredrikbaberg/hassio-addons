ARG BUILD_FROM="homeassistant/amd64-base:latest"

ARG PIP_FLAGS="--no-cache-dir"

FROM ${BUILD_FROM} AS final
ARG PIP_FLAGS
ENV LANG C.UTF-8
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Install requirements to run
RUN apk add --no-cache --virtual .necessary supervisor dbus avahi python3 haproxy
RUN apk add --no-cache --virtual .extra avahi-compat-libdns_sd libjpeg ffmpeg
# Install OctoPrint
RUN apk add --no-cache --virtual .build-dependencies py3-virtualenv build-base python3-dev linux-headers zlib-dev jpeg-dev musl-dev \
    && apk add --no-cache --virtual .build-dependencies-mjpgstreamer cmake libexecinfo-dev libjpeg-turbo-dev \
    ## octoprint
    && echo "Install OctoPrint" \
    && virtualenv --python=python3 /data/python \
    && source /data/python/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip \
    && pip install ${PIP_FLAGS} OctoPrint \
    && pip install ${PIP_FLAGS} https://github.com/kounch/pybonjour-python3/archive/master.zip \
    # Cleanup, move output
    && find /data/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache \
    && cd /data && tar -zcf /root/python.tar.gz python \
    && rm -rf /data/python \
    ## mjpg-streamer
    && echo "Install mjpg-streamer" \
    && wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz \
    && cd mjpg-streamer-master/mjpg-streamer-experimental/ \
    && make --silent \
    # && make CMAKE_BUILD_TYPE=Debug --silent \
    && make install --silent \
    # Move files
    && mv www/ /www_mjpg \
    # Cleanup mjpg-streamer
    && rm -rf /mjpg-streamer-master \
    ## Final cleanup
    && apk del --no-cache .build-dependencies .build-dependencies-mjpgstreamer
# Copy data from filesystem and previous stages
COPY FS/ /
# Make scripts executable
RUN chmod a+x /*.sh
# Make sure scripts are formatted for Unix
RUN dos2unix /run_dev.sh
WORKDIR /
CMD [ "/run.sh" ]
