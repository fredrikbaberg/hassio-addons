ARG BUILD_FROM="ghcr.io/home-assistant/amd64-base:3.14"
ARG OCTOPRINT_VERSION="1.7.2"
ARG MJPG_STREAMER_BRANCH="v1.0.0"
ARG CURA_LEGACY_BRANCH="legacy"
ARG KLIPPER_BRANCH="master"
ARG MOONRAKER_BRANCH="master"

FROM ${BUILD_FROM} AS build-base
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir"
# ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
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
ENV PYTHONPATH=/data/python/octoprint
ENV PYTHONUSERBASE=/data/python/octoprint
ENV PATH=${PATH}:/data/python/octoprint/bin

RUN echo "Install OctoPrint" \
    && apk add --no-cache \
        build-base \
        linux-headers \
        postgresql-dev \
        py3-virtualenv \
        python3-dev \
    && echo "Done with apk add"
RUN echo "Install" \
    && virtualenv --python=python3 /data/python/octoprint \
    && source /data/python/octoprint/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel \
        cython \
    && pip install ${PIP_FLAGS} --upgrade \
        OctoPrint==${OCTOPRINT_VERSION} \
    && pip install ${PIP_FLAGS} \
        marlin-binary-protocol \
        psycopg2 \
    && find /data/python/octoprint | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data && tar -zcf /copy/root/octoprint-python.tar.gz python/octoprint \
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
ENV PYTHONPATH=/data/python/klipper
ENV PYTHONUSERBASE=/data/python/klipper
ENV PATH=${PATH}:/data/python/klipper/bin

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
    && virtualenv --python=python3 /data/python/klipper \
    && source /data/python/klipper/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel \
    && git clone --single-branch --branch ${KLIPPER_BRANCH} https://github.com/Klipper3d/klipper.git /data/src/klipper \
    && pip install ${PIP_FLAGS} -r /data/src/klipper/scripts/klippy-requirements.txt \
    # && pip install ${PIP_FLAGS} --upgrade \
    #     numpy \
    && find /data/python/klipper | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache
COPY rootfs/root/src/klipper/.config /data/src/klipper/.config
RUN cd /data/src/klipper \
    && sed -i 's"// sched_main"// sched_main\n#include <pthread.h>"' /data/src/klipper/src/linux/main.c \
    && sed -i 's/sched_setscheduler(0/pthread_setschedparam(pthread_self()/' /data/src/klipper/src/linux/main.c \
    && make clean \
    && make \
    && ./scripts/flash-linux.sh \
    && make clean
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data && tar -zcf /copy/root/klipper-python.tar.gz python/klipper \
    && cd /data && tar -zcf /copy/root/klipper-src.tar.gz src/klipper \
    && mkdir -p /copy/usr/local/bin \
    && cp /usr/local/bin/klipper_mcu /copy/usr/local/bin/klipper_mcu



FROM build-base AS moonraker
ARG MOONRAKER_BRANCH
ENV PYTHONPATH=/data/python/moonraker
ENV PYTHONUSERBASE=/data/python/moonraker
ENV PATH=${PATH}:/data/python/moonraker/bin

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
    && virtualenv --python=python3 /data/python/moonraker \
    && source /data/python/moonraker/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel \
    && git clone --single-branch --branch ${MOONRAKER_BRANCH} https://github.com/Arksine/moonraker.git /data/src/moonraker \
    && pip install ${PIP_FLAGS} -r /data/src/moonraker/scripts/moonraker-requirements.txt \
    && find /data/python/moonraker | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data && tar -zcf /copy/root/moonraker-python.tar.gz python/moonraker \
    && cd /data && tar -zcf /copy/root/moonraker-src.tar.gz src/moonraker



FROM ${BUILD_FROM} AS final
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"
ENV PATH=/data/python/octoprint/bin:/data/python/klipper/bin:/data/python/moonraker/bin:/data/bin:${PATH}

RUN echo "Install required packages for proxy" \
    && apk add --no-cache \
        caddy
RUN echo "Install required packages for OctoPrint" \
    && apk add --no-cache \
        python3
RUN echo "Install required packages for camera (mjpg-streamer, gphoto2)." \
    && apk add --no-cache \
        ffmpeg \
        gphoto2 \
        v4l-utils
RUN echo "Install required packages for Klipper." \
    && apk add --no-cache \
        build-base \
        libffi-dev \
        linux-headers \
        python2 \
        python3
RUN echo "Install required packages for Moonraker." \
    && apk add --no-cache \
        curl-dev \
        libsodium-dev \
        sudo
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

COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /
