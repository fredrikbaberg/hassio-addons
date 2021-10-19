## Alpine-based
ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} AS build-base
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"

RUN apk add --no-cache --virtual .build \
        build-base \
        cmake \
        git \
        linux-headers \
        py3-virtualenv \
        python2-dev \
        python3-dev



FROM build-base AS octoprint
ENV PYTHONPATH=/data/python/OctoPrint
ENV PYTHONUSERBASE=/data/python/OctoPrint
ENV PATH=${PATH}:/data/python/OctoPrint/bin

RUN echo "Install OctoPrint" \
    && virtualenv --python=python3 /data/python/OctoPrint \
    && source /data/python/OctoPrint/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel \
    && pip install ${PIP_FLAGS} --upgrade \
        OctoPrint \
    && find /data/python/OctoPrint | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data/python && tar -zcf /copy/root/OctoPrint-python.tar.gz OctoPrint



FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"
ENV PATH=${PATH}:/data/python/OctoPrint/bin

RUN echo "Install required packages for running." \
    && apk add --no-cache \
        python3 \
        nginx

# Clean up nginx config
RUN rm -rf /etc/nginx/http.d/*

# Copy data from previous stages
COPY --from=octoprint /copy /
RUN ln -s /data/config/octoprint $HOME/.octoprint

COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /
