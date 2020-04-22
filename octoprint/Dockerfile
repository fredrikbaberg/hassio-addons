ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Enable/disable features here, instead of in code.
ENV INSTALL_OCTOPRINT=1
ENV INSTALL_CURA_LEGACY=0
ENV INSTALL_MJPEG=0

# If version has to be specified, do so here.Set version number here instead of in code.
ENV OCTOPRINT_VERSION=1.4.0

# To slice on OctoPrint using CURA we need to use this legacy version.
ENV CURA_VERSION=15.04.6

# ENV CAMERA_DEV /dev/video0
# ENV STREAMER_FLAGS -y -n

# To have Python packages persistently installed.
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Change to tmp folder for all installs, easier to clean
WORKDIR /tmp

# Install requirements for add-on
RUN if [ "${INSTALL_OCTOPRINT}" != "0" ]; then \
        echo "Installing OctoPrint" && \
        apk add --no-cache py-pip supervisor haproxy avahi-compat-libdns_sd dbus avahi && \
        apk add --no-cache --virtual .build-dependencies build-base linux-headers python-dev && \
        # pip install --user https://goo.gl/SxQZ06 --quiet && \
        pip install --user octoprint && \
        apk del --no-cache .build-dependencies \
    ; fi \
    # # Cleanup
    && cp -R /data/python /root/ \
    && rm -rf /tmp

# Copy data for add-on
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY supervisord.conf /etc/supervisord.conf
COPY run.sh /
RUN chmod a+x /run.sh
COPY debug.sh /
RUN chmod a+x /debug.sh
WORKDIR /
CMD [ "/run.sh" ]
# CMD [ "/debug.sh" ]
