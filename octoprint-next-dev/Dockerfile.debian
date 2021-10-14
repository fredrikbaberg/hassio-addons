## Debian-based
ARG BUILD_FROM="homeassistant/amd64-base-debian:bullseye"


FROM ${BUILD_FROM} AS build-base
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"

RUN echo "Install core build dependencies" \
    && apt update && apt install -y \
        git \
        python3-dev \
        python2-dev \
        virtualenv \
        build-essential \
        cmake



FROM build-base AS octoprint
ENV PYTHONPATH=/data/python/OctoPrint
ENV PYTHONUSERBASE=/data/python/OctoPrint
ENV PATH=${PATH}:/data/python/OctoPrint/bin

RUN echo "Install OctoPrint" \
    && virtualenv --python=python3 /data/python/OctoPrint \
    && source /data/python/OctoPrint/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip wheel \
    && pip install ${PIP_FLAGS} --upgrade OctoPrint



FROM build-base AS klipper
ENV PYTHONPATH=/data/python/Klipper
ENV PYTHONUSERBASE=/data/python/Klipper
ENV PATH=${PATH}:/data/python/Klipper/bin

RUN echo "Install Klipper" \
    && apt update && apt install -y \
        libffi-dev \
    && virtualenv --python=python2.7 /data/python/Klipper \
    && source /data/python/Klipper/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip wheel \
    && git clone --depth 1 https://github.com/Klipper3d/klipper.git /data/klipper \
    && pip install ${PIP_FLAGS} -r /data/klipper/scripts/klippy-requirements.txt \
    && pip install ${PIP_FLAGS} --upgrade numpy
COPY rootfs/data/klipper/.config /data/klipper/.config
# Need to make two changes to /data/klipper/src/linux/main.c due to sched_setscheduler not being available in Alpine:
# - Add #include<pthread.h>
# - Replace sched_setscheduler(0, SCHED_FIFO, &sp); with pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp);
RUN sed -i 's"// sched_main"// sched_main\n#include <pthread.h>"' /data/klipper/src/linux/main.c
RUN sed -i 's/sched_setscheduler(0/pthread_setschedparam(pthread_self()/' /data/klipper/src/linux/main.c
RUN cd /data/klipper \
    && make clean \
    && make \
    && ./scripts/flash-linux.sh



FROM build-base AS mjpg-streamer
RUN echo "Install mjpg-streamer" \
    && apt update && apt install -y \
        libjpeg-dev \
    && git clone --depth 1 https://github.com/jacksonliam/mjpg-streamer \
    && cd mjpg-streamer/mjpg-streamer-experimental/ \
    && make --silent \
    && make install --silent \
    && mv www/ /www_mjpg



FROM build-base AS curaengine
ARG CURA_VERSION=15.04.6
RUN echo "Install CuraEngine" \
    && git clone -b ${CURA_VERSION} --depth 1 https://github.com/Ultimaker/CuraEngine \
    && cd CuraEngine \
    && make --silent \
    && mv build/CuraEngine /usr/local/bin/CuraEngine



# FROM build-base AS superslicer
# RUN echo "Install dependencies" \
#     && apt update && apt install -y \
#         git \
#         libgtk2.0-dev \
#         libglew-dev \
#         libudev-dev \
#         libdbus-1-dev \
#         build-essential \
#         cmake \
#         m4 \
#     && apt clean \
#     && rm -rf /var/lib/apt/lists/* \
#     && echo "Prepare SuperSlicer files" \
#     && git clone --depth 1 https://github.com/supermerill/SuperSlicer.git \
#     && sed -i "s/+UNKNOWN/_$(date '+%F')/" /SuperSlicer/version.inc \
#     && cd /SuperSlicer/resources/profiles && git submodule update --init \
#     && echo "Setup deps" \
#     && mkdir -p /SuperSlicer/deps/build && cd /SuperSlicer/deps/build \
#     && cmake .. \
#     && make --silent \
#     && cd /SuperSlicer/deps/build/destdir/usr/local/lib/ \
#     && cp libwxscintilla-3.1.a libwx_gtk2u_scintilla-3.1.a \
#     && ls /SuperSlicer/deps/build/destdir/usr/local/lib \
#     && rm -rf /SuperSlicer/deps/build/dep_* \
#     && echo "Build and install SuperSlicer" \
#     && mkdir -p /SuperSlicer/build \
#     && cd /SuperSlicer/build \
#     && cmake .. -DCMAKE_PREFIX_PATH="/SuperSlicer/deps/build/destdir/usr/local" -DSLIC3R_STATIC=1 -DSLIC3R_FHS=1 -DSLIC3R_GUI=0 \
#     && make --silent \
#     && make install --silent



FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV PATH=${PATH}:/data/python/OctoPrint/bin:/data/python/Klipper/bin

RUN echo "Install required packages for running." \
    && apt update && apt install -y \
        python2 \
        python3 \
        python3-distutils \
        debian-keyring \
        debian-archive-keyring \
        apt-transport-https \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | tee /etc/apt/trusted.gpg.d/caddy-stable.asc \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt update \
    && apt install caddy \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
RUN echo "Install additional packages" \
    && apt update && apt install -y --no-install-recommends \
        gphoto2 \
        ffmpeg \
        libjpeg-dev \
        zlib1g \
        build-essential \
        python3-dev \
        slic3r \
        vim \
        git \
        avrdude \
        dfu-programmer \
        dfu-util \
        stm32flash \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Copy data from previous stages and do some setup.
# ## OctoPrint
COPY --from=octoprint /data/python/OctoPrint /data/python/OctoPrint
COPY rootfs/data/config/octoprint /data/config/octoprint
RUN ln -s /data/config/octoprint $HOME/.octoprint
# ## mjpg-streamer
COPY --from=mjpg-streamer /usr/local/lib/mjpg-streamer /usr/local/lib/mjpg-streamer
COPY --from=mjpg-streamer /usr/local/share/mjpg-streamer /usr/local/share/mjpg-streamer
COPY --from=mjpg-streamer /usr/local/bin/mjpg_streamer /usr/local/bin/mjpg_streamer
COPY --from=mjpg-streamer /www_mjpg /www_mjpg
# ## Klipper
COPY --from=klipper /data/python/Klipper /data/python/Klipper
COPY --from=klipper /data/klipper /data/klipper
COPY --from=klipper /usr/local/bin/klipper_mcu /usr/local/bin/klipper_mcu
# ## CuraEngine
COPY --from=curaengine /usr/local/bin/CuraEngine /usr/local/bin/CuraEngine
# ## SuperSlicer
# COPY --from=superslicer /usr/local/share/SuperSlicer /usr/local/share/SuperSlicer
# COPY --from=superslicer /usr/local/bin/superslicer /usr/local/bin/superslicer

COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /

# Cleanup, move files in /data to archives.
RUN echo "Cleanup and move output" \
    && mkdir -p /data/python/OctoPrint \
    && mkdir -p /data/python/Klipper \
    && mkdir -p /data/klipper \
    && find /data/python/OctoPrint | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /data/python/Klipper | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache \
    && cd /data/python && tar -zcf /root/OctoPrint-python.tar.gz OctoPrint \
    && cd /data/config && tar -zcf /root/OctoPrint-config.tar.gz octoprint \
    && cd /data/python && tar -zcf /root/Klipper-python.tar.gz Klipper \
    && cd /data && tar -zcf /root/Klipper-src.tar.gz klipper \
    && rm -rf /data/*
