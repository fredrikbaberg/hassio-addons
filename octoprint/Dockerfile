ARG BUILD_FROM="homeassistant/amd64-base:latest"

ARG OCTOPRINT_VERSION="1.4.0"
ARG CONFIG_DIR_SUFFIX=""
ARG PIP_FLAGS="--no-cache-dir"
ARG PYTHON_VERSION="python2"

FROM alpine:latest AS curaengine-legacy
ARG CURA_VERSION=15.04.6
WORKDIR /tmp
RUN apk add --no-cache --virtual .build-dependencies build-base libexecinfo-dev \
    && wget -qO- https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz | tar xz \
    && cd CuraEngine-${CURA_VERSION} \
    && make --quiet \
    && mkdir -p /root/copy/sbin/ \
    && mv build/CuraEngine /root/copy/sbin/CuraEngine \
    # Cleanup, should result in smaller stages (at the cost of time)
    && rm -rf /tmp \
    && apk del --no-cache .build-dependencies

FROM alpine:latest AS mjpg-streamer
WORKDIR /tmp
RUN apk add --no-cache --virtual .build-dependencies build-base cmake linux-headers libexecinfo-dev libjpeg-turbo-dev \
    && wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz \
    && cd mjpg-streamer-master/mjpg-streamer-experimental/ \
    && make --quiet \
    && make install --quiet \
    # Move files to /root/ for easier copy.
    && mkdir -p /root/copy/usr/local/lib/mjpg-streamer \
    && cp *.so /root/copy/usr/local/lib/mjpg-streamer/ \
    && mkdir -p /root/copy/usr/local/bin \
    && cp /usr/local/bin/mjpg_streamer /root/copy/usr/local/bin/ \
    # Cleanup
    && apk del --no-cache .build-dependencies \
    && rm -rf /tmp

FROM ${BUILD_FROM} AS final
ARG OCTOPRINT_VERSION
ARG CONFIG_DIR_SUFFIX
ARG PIP_FLAGS
ARG PYTHON_VERSION
ENV LANG C.UTF-8
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python
# Install requirements to run
RUN apk add --no-cache --virtual .necessary haproxy ${PYTHON_VERSION} dbus avahi supervisor
RUN apk add --no-cache --virtual .extra avahi-compat-libdns_sd postgresql-libs libjpeg ffmpeg
# Install OctoPrint
RUN echo "Installing OctoPrint" \
    && apk add --no-cache --virtual .build-dependencies \
       py3-virtualenv build-base ${PYTHON_VERSION}-dev linux-headers \
       avahi-compat-libdns_sd \
       postgresql-dev \
    && virtualenv --python=${PYTHON_VERSION} /data/python \
    && source /data/python/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip \
    && pip install ${PIP_FLAGS} OctoPrint==${OCTOPRINT_VERSION} \
    # && pip install supervisor \
    # The following steps, until cleanup, are optional and could be skipped if small size is required (loosing pybonjour, psycopg2 [for filamentmanager] )
    && if [ "${PYTHON_VERSION}" = "python2" ]; then \
            pip install ${PIP_FLAGS} https://goo.gl/SxQZ06 ; \
       else \
            pip install ${PIP_FLAGS} https://github.com/kounch/pybonjour-python3/archive/master.zip ; \
       fi \
    && pip install ${PIP_FLAGS} psycopg2 \
    # Cleanup and move output /root/python
    && find /data/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache \
    && apk del --no-cache .build-dependencies \
    && cd /data && tar -zcf /root/python.tar.gz python \
    && rm -rf /data/python
    # && mv /data/python /root/python
# Copy data from filesystem and previous stages
COPY FS/ /
COPY --from=curaengine-legacy /root/copy/ /
COPY --from=mjpg-streamer /root/copy /
# Make scripts executable
RUN chmod a+x /*.sh
RUN dos2unix /run_dev.sh # For development purposes
RUN echo "Update config directory for all files" \
    && sed -i "s#/config/octoprint#/config/octoprint${CONFIG_DIR_SUFFIX}#g" /etc/supervisord.conf \
    && sed -i "s#/config/octoprint#/config/octoprint${CONFIG_DIR_SUFFIX}#g" /run.sh \
    && sed -i "s#/config/octoprint#/config/octoprint${CONFIG_DIR_SUFFIX}#g" /run_dev.sh \
    && sed -i "s#/config/octoprint#/config/octoprint${CONFIG_DIR_SUFFIX}#g" /config_octoprint.yaml
WORKDIR /
CMD [ "/run.sh" ]
