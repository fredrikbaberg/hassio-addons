ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Enable/disable features here, instead of in code.
ENV INSTALL_OCTOPRINT=1
ENV INSTALL_CURA_LEGACY=1
ENV INSTALL_CAMERA_SUPPORT=1

# Specify versions here instead of in code.
ENV OCTOPRINT_VERSION=1.4.0

# To slice in OctoPrint using CURA we need this legacy version (and a plugin).
ENV CURA_VERSION=15.04.6

# Environment variables for build and run
# ENV CAMERA_DEV /dev/video0
# ENV STREAMER_FLAGS -y -n

# To have Python packages persistently installed.
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Change to tmp folder for all installs, easier to clean
WORKDIR /tmp

# Install requirements for add-on
RUN apk add --no-cache --virtual .necessary supervisor haproxy avahi-compat-libdns_sd dbus avahi python2 \
    && apk add --no-cache --virtual .build-dependencies build-base cmake linux-headers libjpeg-turbo-dev python2-dev libexecinfo-dev py2-pip \
    && if [ "${INSTALL_OCTOPRINT}" != "0" ]; then \
        echo "Installing OctoPrint" \
        && pip install virtualenv \
        && virtualenv /data/python \
        && source /data/python/bin/activate \
        && pip install OctoPrint==${OCTOPRINT_VERSION} \
        && pip install --user https://goo.gl/SxQZ06 --quiet \
        && cp -R /data/python /root/ \
    ; fi \
    && if [ "${INSTALL_CAMERA_SUPPORT}" != "0" ]; then \
        echo "Installing camera support" \
        && apk add --no-cache ffmpeg \
        && cd /tmp \
        && wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz \
        && cd /tmp/mjpg-streamer-master/mjpg-streamer-experimental/ \
        && make --quiet \
        && make install --quiet \
        && cd /tmp \
    ; fi \
    && if [ "${INSTALL_CURA_LEGACY}}" != "0" ]; then \
        echo "Installing CuraLegacy" \
        && cd /tmp \
        && wget -qO- https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz | tar xz \
        && cd /tmp/CuraEngine-${CURA_VERSION} \
        && mkdir -p build \
        && make --quiet \
        && cp build/CuraEngine /sbin/CuraEngine \
        && source /data/python/bin/activate \
        && pip install "https://github.com/OctoPrint/OctoPrint-CuraLegacy/archive/master.zip" \
    ; fi \
    # # Cleanup
    && apk del --no-cache .build-dependencies \
    && rm -rf /tmp

# Copy data for add-on
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY supervisord.conf /etc/supervisord.conf
COPY run.sh /run.sh
COPY run_dev.sh /run_dev.sh
RUN chmod a+x /run.sh
WORKDIR /
CMD [ "/run.sh" ]
