ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} AS final

ENV PIP_FLAGS="--no-cache-dir"
ENV LANG C.UTF-8
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Install requirements to run
RUN echo "Install base requirements for running." \
    && apk add --no-cache --virtual .necessary python3 caddy \
    && apk add --no-cache --virtual .extras ffmpeg # libjpeg postgresql-libs python3-dev zlib-dev jpeg-dev build-base linux-headers
RUN echo "Install software" \
    && apk add --no-cache --virtual .build-dependencies-octoprint py3-virtualenv build-base python3-dev linux-headers \
    && echo "Setup Python" \
    && virtualenv --python=python3 /data/python \
    && source /data/python/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip \
    && echo "Install OctoPrint" \
    && pip install ${PIP_FLAGS} OctoPrint \
    && pip install ${PIP_FLAGS} zeroconf \
    # Cleanup, move output
    && find /data/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache \
    && cd /data && tar -zcf /root/python.tar.gz python \
    && rm -rf /data/python \
    ## Final cleanup
    && apk del --no-cache .build-dependencies-octoprint
# Copy data from filesystem and previous stages
COPY rootfs/ /
RUN chmod a+x /restart.sh
RUN chmod a+x /shutdown.sh
WORKDIR /
