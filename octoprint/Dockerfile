ARG BUILD_FROM

ARG OCTOPRINT_VERSION=1.4.0
ARG CURA_VERSION=15.04.6
ARG OCTOPRINT_CONFIG_DIR=octoprint_experimental
ARG PYTHON_VERSION="python2"
ARG PIP_FLAGS="--no-cache-dir"

FROM alpine:latest AS build-octoprint-python2
ARG OCTOPRINT_VERSION
ARG PIP_FLAGS
# OctoPrint
RUN echo "Installing OctoPrint" \
    && apk add --no-cache --virtual .build-dependencies build-base cmake linux-headers libjpeg-turbo-dev libexecinfo-dev avahi-compat-libdns_sd postgresql-dev python2-dev py2-pip py3-virtualenv \
    && virtualenv --python=python2 /data/python \
    && source /data/python/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip \
    && pip install ${PIP_FLAGS} OctoPrint==${OCTOPRINT_VERSION} \
    && pip install ${PIP_FLAGS} psycopg2 \
    && pip install ${PIP_FLAGS} https://goo.gl/SxQZ06 \
    # Cleanup, should result in smaller stages (at the cost of time)
    && find /data/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && apk del --no-cache .build-dependencies

FROM alpine:latest AS build-octoprint-python3
# Specify versions here instead of in code.
ARG OCTOPRINT_VERSION
ARG PIP_FLAGS
# OctoPrint
RUN echo "Installing OctoPrint" \
    && apk add --no-cache --virtual .build-dependencies build-base cmake linux-headers libjpeg-turbo-dev libexecinfo-dev avahi-compat-libdns_sd postgresql-dev python3-dev py3-pip py3-virtualenv \
    && virtualenv --python=python3 /data/python \
    && source /data/python/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip \
    && pip install ${PIP_FLAGS} OctoPrint==${OCTOPRINT_VERSION} \
    && pip install ${PIP_FLAGS} psycopg2 \
    && pip install ${PIP_FLAGS} https://github.com/kounch/pybonjour-python3/archive/master.zip \
    # Cleanup, should result in smaller stages (at the cost of time)
    && find /data/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && apk del --no-cache .build-dependencies

FROM alpine:latest AS build-curaengine
ARG CURA_VERSION
# CuraLegacy
RUN echo "Installing CuraLegacy" \
    && apk add --no-cache --virtual .build-dependencies build-base libexecinfo-dev \
    && cd /tmp \
    && wget -qO- https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz | tar xz \
    && cd CuraEngine-${CURA_VERSION} \
    && make --quiet \
    && mv build/CuraEngine /sbin/CuraEngine \
    # Cleanup, should result in smaller stages (at the cost of time)
    && rm -rf /tmp \
    && apk del --no-cache .build-dependencies

FROM alpine:latest AS build-camera
# Camera support
RUN echo "Installing camera support" \
    && apk add --no-cache --virtual .build-dependencies build-base cmake linux-headers libexecinfo-dev libjpeg-turbo-dev \
    && apk add --no-cache ffmpeg \
    && cd /tmp \
    && wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz \
    && cd /tmp/mjpg-streamer-master/mjpg-streamer-experimental/ \
    && make --quiet \
    && make install --quiet \
    # Move files to /root/ for easier copy.
    && mkdir -p /root/usr/local/lib/mjpg-streamer \
    && cp *.so /root/usr/local/lib/mjpg-streamer/ \
    && mkdir -p /root/usr/local/bin \
    && cp /usr/local/bin/mjpg_streamer /root/usr/local/bin/ \
    # Cleanup
    && apk del --no-cache .build-dependencies \
    && rm -rf /tmp

# COPY doesn´t support ARG, this line is to select version
FROM build-octoprint-${PYTHON_VERSION} AS octoprint

FROM ${BUILD_FROM} AS main
ENV LANG C.UTF-8
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python
ENV OCTOPRINT_CONFIG_DIR=${OCTOPRINT_CONFIG_DIR}
# Install requirements to run
RUN apk add --no-cache --virtual .necessary supervisor haproxy avahi-compat-libdns_sd dbus avahi ${PYTHON_VERSION} postgresql-libs # libjpeg ffmpeg
# Copy data from filesystem and previous stages
COPY --from=octoprint /data/python /root/python
COPY --from=build-curaengine /sbin/CuraEngine /sbin/CuraEngine
# COPY --from=build-camera /root/usr /usr/
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY supervisord.conf /etc/supervisord.conf
COPY run.sh /run.sh
RUN chmod a+x /run.sh
WORKDIR /
CMD [ "/run.sh" ]
