ARG BUILD_FROM="homeassistant/amd64-base-debian:bullseye"
ARG OCTOPRINT_VERSION="1.7.3"
ARG MJPG_STREAMER_BRANCH="v1.0.0"
ARG CURA_LEGACY_BRANCH="1.15.04.6"

FROM ${BUILD_FROM} AS mjpg-streamer
ARG MJPG_STREAMER_BRANCH
RUN echo "Install mjpg-streamer" \
    && apt update \
    && apt install -y \
        git \
        make \
        cmake \
        libjpeg-dev \
        gcc \
        g++ \
    && echo "Done with apk add"
RUN echo "Install" \
    && git clone --single-branch --branch ${MJPG_STREAMER_BRANCH} https://github.com/jacksonliam/mjpg-streamer \
    && cd mjpg-streamer/mjpg-streamer-experimental/ \
    && make --silent \
    && make install --silent \
    && make clean \
    && mv www /www_mjpg
RUN echo "Copy files to single folder" \
    && mkdir -p /copy \
    && cp -R /www_mjpg /copy/www_mjpg \
    && mkdir -p /copy/usr/local/lib/ \
    && cp -R /usr/local/lib/mjpg-streamer /copy/usr/local/lib/ \
    && mkdir -p /copy/usr/local/share/ \
    && cp -R /usr/local/share/mjpg-streamer /copy/usr/local/share/ \
    && mkdir -p /copy/usr/local/bin/ \
    && cp -R /usr/local/bin/mjpg_streamer /copy/usr/local/bin/


FROM ${BUILD_FROM} AS curaengine
ARG CURA_LEGACY_BRANCH
RUN echo "Install CuraEngine" \
    && apt update \
    && apt install -y \
        git \
        cmake \
        g++
RUN echo "Install" \
    && git clone --single-branch --branch ${CURA_LEGACY_BRANCH} https://github.com/Ultimaker/CuraEngine \
    && cd CuraEngine \
    && make --silent \
    && mv build/CuraEngine /usr/local/bin/CuraEngine
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/usr/local/bin/ \
    && cp /usr/local/bin/CuraEngine /copy/usr/local/bin/CuraEngineLegacy


FROM ${BUILD_FROM} as final
ARG OCTOPRINT_VERSION
ENV PYTHONPATH=/data/python/octoprint
ENV PYTHONUSERBASE=/data/python/octoprint
ENV PATH=${PATH}:/data/python/octoprint/bin

# Start size: 105M
RUN echo "Preliminaries" \
    && apt update \
    && apt install -y --no-install-recommends \
        python3-venv \
    && python3 -m venv /data/python/octoprint \
    && source /data/python/octoprint/bin/activate \
    && pip install --upgrade \
        pip \
        wheel \
    && echo "Install OctoPrint" \
    && pip install --upgrade \
        OctoPrint==${OCTOPRINT_VERSION} \
    && echo "Cleanup OctoPrint install" \
    && find /data/python/octoprint | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache \
    && echo "Package OctoPrint" \
    && mkdir -p /root \
    && cd /data && tar -zcf /root/octoprint-python.tar.gz python/octoprint \
    && ln -s /data/config/octoprint /root/.octoprint \
    && rm -rf /data \
    && apt install -y \
        build-essential \
    && echo "Install Caddy" \
    && apt install -y \
        debian-keyring \
        debian-archive-keyring \
        apt-transport-https \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | tee /etc/apt/trusted.gpg.d/caddy-stable.asc \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt update \
    && apt install caddy \
    && echo "Cleanup" \
    && apt clean

# Copy data from previous stages
## mjpg-streamer
COPY --from=mjpg-streamer /copy /
## CuraEngineLegacy
COPY --from=curaengine /copy /

# Copy files into image.
COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /


# FROM ${BUILD_FROM} AS final
# ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
# ENV CFLAGS="-fcommon"
# ENV PATH=/data/python/octoprint/bin:/data/python/klipper/bin:/data/python/moonraker/bin:/data/bin:${PATH}

# RUN echo "Install required packages for proxy" \
#     && apk add --no-cache \
#         caddy
# RUN echo "Install required packages for OctoPrint" \
#     && apk add --no-cache \
#         python3
# RUN echo "Install required packages for camera (mjpg-streamer, gphoto2)." \
#     && apk add --no-cache \
#         ffmpeg \
#         gphoto2 \
#         v4l-utils
# RUN echo "Install required packages for Klipper." \
#     && apk add --no-cache \
#         build-base \
#         libffi-dev \
#         linux-headers \
#         python2 \
#         python3
# RUN echo "Install required packages for Moonraker." \
#     && apk add --no-cache \
#         curl-dev \
#         libsodium-dev \
#         sudo
# RUN echo "Install development packages for different plugins etc." \
#     && apk add --no-cache \
#         build-base \
#         libjpeg-turbo-dev \
#         linux-headers \
#         postgresql-dev \
#         python3-dev \
#         zlib-dev
# RUN echo "Install required packages for firmware update." \
#     && apk add --no-cache \
#         avrdude \
#         git \
#         stm32flash

