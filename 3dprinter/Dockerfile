ARG BUILD_FROM="homeassistant/amd64-base:latest"
ARG OCTOPRINT_VERSION="1.6.1"
ARG MJPG_STREAMER_BRANCH="v1.0.0"
ARG CURA_LEGACY_BRANCH="15.04.6"
ARG KLIPPER_BRANCH="master"
ARG MOONRAKER_BRANCH="master"

FROM ${BUILD_FROM} AS build-base
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"

RUN echo "Install common dependencies" \
    && apk add --no-cache --virtual .build \
        ## OctoPrint \
        build-base \
        linux-headers \
        postgresql-dev \
        py3-virtualenv \
        python3-dev \
        ## mjpg-streamer \
        libjpeg-turbo-dev \
        git \
        build-base \
        cmake \
        linux-headers \
        ## Klipper \
        build-base \
        git \
        libffi-dev \
        py3-virtualenv \
        python2-dev \
        python3-dev \
        ## Moonraker \
        build-base \
        curl-dev \
        git \
        libjpeg-turbo-dev \
        py3-virtualenv \
        python3-dev \
        ## Cura Engine \
        build-base \
        git \
        libexecinfo-dev \
    && echo "Done with build-base"


FROM build-base AS octoprint
ARG OCTOPRINT_VERSION
ENV PYTHONPATH=/data/python/OctoPrint
ENV PYTHONUSERBASE=/data/python/OctoPrint
ENV PATH=${PATH}:/data/python/OctoPrint/bin

RUN echo "Install OctoPrint" \
    && apk add --no-cache \
        build-base \
        linux-headers \
        postgresql-dev \
        py3-virtualenv \
        python3-dev \
    && echo "Done with apk add"
RUN echo "Install" \
    && virtualenv --python=python3 /data/python/OctoPrint \
    && source /data/python/OctoPrint/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel \
        cython \
    && pip install ${PIP_FLAGS} --upgrade \
        OctoPrint==${OCTOPRINT_VERSION} \
    && pip install ${PIP_FLAGS} \
        marlin-binary-protocol \
        psycopg2 \
    && find /data/python/OctoPrint | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data/python && tar -zcf /copy/root/OctoPrint-python.tar.gz OctoPrint \
    && ln -s /data/config/octoprint /copy/root/.octoprint



FROM build-base AS mjpg-streamer
ARG MJPG_STREAMER_BRANCH
RUN echo "Install mjpg-streamer" \
    && apk add --no-cache \
        libjpeg-turbo-dev \
        git \
        build-base \
        cmake \
        linux-headers \
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



FROM build-base AS curaengine
ARG CURA_LEGACY_BRANCH
RUN echo "Install CuraEngine" \
    && apk add --no-cache \
        build-base \
        git \
        libexecinfo-dev \
    && echo "Done with apk add"
RUN echo "Install" \
    && git clone --single-branch --branch ${CURA_LEGACY_BRANCH} https://github.com/Ultimaker/CuraEngine \
    && cd CuraEngine \
    && make --silent \
    && mv build/CuraEngine /usr/local/bin/CuraEngine
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/usr/local/bin/ \
    && cp /usr/local/bin/CuraEngine /copy/usr/local/bin/CuraEngineLegacy



FROM build-base AS klipper
ARG KLIPPER_BRANCH
ENV PYTHONPATH=/data/python/Klipper
ENV PYTHONUSERBASE=/data/python/Klipper
ENV PATH=${PATH}:/data/python/Klipper/bin

RUN echo "Install Klipper" \
    && apk add --no-cache \
        build-base \
        git \
        libffi-dev \
        py3-virtualenv \
        python2-dev \
        python3-dev \
    && echo "Done with apk add"
RUN echo "Install" \
    && virtualenv --python=python3 /data/python/Klipper \
    && source /data/python/Klipper/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel \
    && git clone --single-branch --branch ${KLIPPER_BRANCH} https://github.com/Klipper3d/klipper.git /data/klipper \
    && pip install ${PIP_FLAGS} -r /data/klipper/scripts/klippy-requirements.txt \
    # && pip install ${PIP_FLAGS} --upgrade \
    #     numpy \
    && find /data/python/Klipper | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache
COPY rootfs/root/klipper/.config /data/klipper/.config
RUN cd /data/klipper \
    && make clean \
    && make \
    && ./scripts/flash-linux.sh \
    && make clean
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data/python && tar -zcf /copy/root/Klipper-python.tar.gz Klipper \
    && cd /data && tar -zcf /copy/root/Klipper-src.tar.gz klipper \
    && mkdir -p /copy/usr/local/bin \
    && cp /usr/local/bin/klipper_mcu /copy/usr/local/bin/klipper_mcu



FROM build-base AS moonraker
ARG MOONRAKER_BRANCH
ENV PYTHONPATH=/data/python/Moonraker
ENV PYTHONUSERBASE=/data/python/Moonraker
ENV PATH=${PATH}:/data/python/Moonraker/bin

RUN echo "Install Moonraker" \
    && apk add --no-cache \
        build-base \
        curl-dev \
        git \
        libjpeg-turbo-dev \
        py3-virtualenv \
        python3-dev \
    && echo "Done with apk add"
RUN echo "Install" \
    && virtualenv --python=python3 /data/python/Moonraker \
    && source /data/python/Moonraker/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel \
    && git clone --single-branch --branch ${MOONRAKER_BRANCH} https://github.com/Arksine/moonraker.git /data/moonraker \
    && pip install -r /data/moonraker/scripts/moonraker-requirements.txt \
    && find /data/python/Moonraker | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data/python && tar -zcf /copy/root/Moonraker-python.tar.gz Moonraker \
    && cd /data && tar -zcf /copy/root/Moonraker-src.tar.gz moonraker



FROM build-base AS fluidd
ADD https://github.com/cadriel/fluidd/releases/latest/download/fluidd.zip /tmp
RUN mkdir -p /data \
    && unzip /tmp/fluidd.zip -d /data/fluidd
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data && tar -zcf /copy/root/Fluidd.tar.gz fluidd



FROM build-base AS mainsail
ADD https://github.com/meteyou/mainsail/releases/latest/download/mainsail.zip /tmp
RUN mkdir -p /data \
    && unzip /tmp/mainsail.zip -d /data/mainsail
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data && tar -zcf /copy/root/Mainsail.tar.gz mainsail



FROM ${BUILD_FROM} AS final
ENV CFLAGS="-fcommon"
ENV PATH=${PATH}:/data/python/OctoPrint/bin:/data/python/Klipper/bin:/data/python/Moonraker/bin

RUN echo "Install required packages for proxy" \
    && apk add --no-cache \
        nginx
RUN echo "Install required packages for OctoPrint" \
    && apk add --no-cache \
        python3
RUN echo "Install required packages for camera (mjpg-streamer, gphoto2)." \
    && apk add --no-cache \
        ffmpeg \
        gphoto2
RUN echo "Install required packages for Klipper." \
    && apk add --no-cache \
        build-base \
        linux-headers \
        python3 \
        python2
RUN echo "Install required packages for Moonraker." \
    && apk add --no-cache \
        curl-dev \
        libsodium-dev
RUN echo "Install development packages for different plugins etc." \
    && apk add --no-cache \
        build-base \
        libjpeg-turbo-dev \
        linux-headers \
        postgresql-dev \
        python3-dev \
        zlib-dev
RUN echo "Install required packages for firmware update." \
    && apk add --no-cache \
        avrdude \
        git \
        stm32flash
RUN echo "Install useful packages for debugging." \
    && apk add --no-cache \
        screen \
        tree \
        vim

# Copy data from previous stages
# ## octoprint
COPY --from=octoprint /copy /
# # ## mjpg-streamer
COPY --from=mjpg-streamer /copy /
# # ## CuraEngineLegacy
COPY --from=curaengine /copy /
# # ## Klipper
COPY --from=klipper /copy /
# # ## Moonraker
COPY --from=moonraker /copy /
# ## Fluidd
COPY --from=fluidd /copy /
# ## Mainsail
COPY --from=mainsail /copy /

COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /
