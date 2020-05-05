ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

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
RUN apk add --no-cache --virtual .necessary supervisor haproxy avahi-compat-libdns_sd dbus avahi postgresql-libs
# OctoPrint
RUN echo "Installing OctoPrint" \
    && apk add --no-cache --virtual .build-dependencies build-base cmake linux-headers libjpeg-turbo-dev python3-dev libexecinfo-dev py3-pip py3-virtualenv postgresql-dev \
    && export PYTHONDONTWRITEBYTECODE="" \
    && virtualenv /data/python \
    && source /data/python/bin/activate \
    && pip install OctoPrint==${OCTOPRINT_VERSION} --quiet --no-cache-dir \
    && pip install psycopg2 --quiet --no-cache-dir \
    # && pip install https://goo.gl/SxQZ06 --quiet --no-cache-dir \
    && cd /tmp \
    && wget https://github.com/kounch/pybonjour-python3/archive/master.zip \
    && unzip master.zip \
    && cd pybonjour-python3-master \
    && python setup.py install \
    && mv /data/python /root/ \
    && apk del --no-cache .build-dependencies \
    && find /usr/lib/python3.8/ | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /root/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache
# Camera support
RUN echo "Installing camera support" \
    && apk add --no-cache --virtual .build-dependencies build-base cmake linux-headers libexecinfo-dev libjpeg-turbo-dev \
    && apk add --no-cache ffmpeg \
    && cd /tmp \
    && wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz \
    && cd /tmp/mjpg-streamer-master/mjpg-streamer-experimental/ \
    && make --quiet \
    && make install --quiet \
    && apk del --no-cache .build-dependencies \
    && rm -rf /tmp/*
# CuraEngine Legacy
RUN echo "Installing CuraLegacy" \
    && apk add --no-cache --virtual .build-dependencies build-base libexecinfo-dev \
    && cd /tmp \
    && wget -qO- https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz | tar xz \
    && cd CuraEngine-${CURA_VERSION} \
    && make --quiet \
    && cp build/CuraEngine /sbin/CuraEngine \
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
