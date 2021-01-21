ARG BUILD_FROM="homeassistant/amd64-base:latest"

ARG CONFIG_DIR_SUFFIX="_py3"
ARG PIP_FLAGS="--no-cache-dir"

FROM ${BUILD_FROM} AS final
ARG CONFIG_DIR_SUFFIX
ARG PIP_FLAGS
ENV LANG C.UTF-8
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Install requirements to run
RUN apk add --no-cache --virtual .necessary haproxy python3 dbus avahi supervisor
RUN apk add --no-cache --virtual .extra avahi-compat-libdns_sd postgresql-libs libjpeg ffmpeg
RUN apk add --no-cache --virtual .build-dependencies py3-virtualenv build-base python3-dev linux-headers zlib-dev jpeg-dev musl-dev
# Install OctoPrint
RUN echo "Installing OctoPrint" \
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
    && rm -rf /data/python
    # && apk del --no-cache .build-dependencies
# Install mjpg-streamer
RUN apk add --no-cache --virtual .build-dependencies-mjpg-streamer build-base cmake linux-headers libexecinfo-dev libjpeg-turbo-dev \
    && wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz \
    && cd mjpg-streamer-master/mjpg-streamer-experimental/ \
    && make --silent \
    && make install --silent \
    # Move files
    && mv www/ /www_mjpg \
    # Cleanup
    && apk del --no-cache .build-dependencies-mjpg-streamer \
    && rm -rf /mjpg-streamer-master
# Install CuraEngine-Legacy
ARG CURA_VERSION=15.04.6
RUN apk add --no-cache --virtual .build-dependencies-cura-legacy build-base libexecinfo-dev \
    && wget -qO- https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz | tar xz \
    && cd CuraEngine-${CURA_VERSION} \
    && make --quiet \
    && mv build/CuraEngine /sbin/CuraEngine \
    # Cleanup
    && cd .. && rm -rf CuraEngine-${CURA_VERSION} \
    && apk del --no-cache .build-dependencies-cura-legacy
# Copy data from filesystem and previous stages
COPY FS/ /
# Make scripts executable
RUN chmod a+x /*.sh
RUN dos2unix /mjpgstreamer.sh # For development purposes
RUN echo "Update config directory for all files" \
    && sed -i "s#/config/octoprint#/config/octoprint${CONFIG_DIR_SUFFIX}#g" /etc/supervisord.conf \
    && sed -i "s#/config/octoprint#/config/octoprint${CONFIG_DIR_SUFFIX}#g" /run.sh \
    && sed -i "s#/config/octoprint#/config/octoprint${CONFIG_DIR_SUFFIX}#g" /octoprint/config.yaml
WORKDIR /
CMD [ "/run.sh" ]
