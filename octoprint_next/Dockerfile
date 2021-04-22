ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} as ustreamer
ENV LANG C.UTF-8
RUN echo "Install base requirements." && \
    apk add --no-cache --virtual .build-dependencies \
        make \
        build-base \
        linux-headers \
        libjpeg-turbo-dev \
        libevent-dev \
        libbsd-dev
RUN wget -qO- https://github.com/pikvm/ustreamer/archive/master.tar.gz | tar xz && \
    cd ustreamer-master && \
    WITH_PTHREAD_NP=0 WITH_OMX=0 WITH_GPIO=0 make --silent && \
    make install

FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir"
ENV CFLAGS="-fcommon"
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Install requirements to run
RUN echo "Install base requirements for running." && \
    apk add --no-cache --virtual .necessary python3 caddy ffmpeg && \
    apk add --no-cache --virtual .extras \
        build-base \
        linux-headers \
        python3-dev \
        zlib-dev \
        jpeg-dev
        # libjpeg postgresql-libs
RUN echo "Install packages for installing" && \
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
        zeroconf \
        pillow && \
    # Cleanup, move output
    find /data/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    rm -rf /root/.cache && \
    cd /data && tar -zcf /root/python.tar.gz python && \
    rm -rf /data/python && \
    ## Final cleanup
    apk del --no-cache .build-dependencies-octoprint
RUN echo "For ustreamer" && \
    apk add --no-cache \
        libjpeg \
        libevent \
        libbsd
# Copy data from filesystem and previous stages
COPY --from=ustreamer /usr/local/bin/ustreamer /usr/local/bin/ustreamer
COPY rootfs/ /
RUN chmod a+x /restart.sh
RUN chmod a+x /shutdown.sh
WORKDIR /
