ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} AS build-base
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"

RUN apk add --no-cache --virtual .build \
        build-base \
        python3-dev \
        python2-dev \
        py3-virtualenv \
        linux-headers \
        git \
        cmake



FROM build-base AS octoprint
ENV PYTHONPATH=/data/python/OctoPrint
ENV PYTHONUSERBASE=/data/python/OctoPrint
ENV PATH=${PATH}:/data/python/OctoPrint/bin

RUN echo "Install OctoPrint" \
    && python3 -m venv /data/python/OctoPrint \
    && source /data/python/OctoPrint/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip wheel \
    && pip install ${PIP_FLAGS} --upgrade OctoPrint
COPY rootfs/data/config/octoprint /data/config/octoprint



FROM build-base AS klipper
ENV PYTHONPATH=/data/python/Klipper
ENV PYTHONUSERBASE=/data/python/Klipper
ENV PATH=${PATH}:/data/python/Klipper/bin

RUN apk add --no-cache \
        libffi-dev \
        freetype-dev \
        libpng-dev

RUN echo "Install Klipper" \
    && virtualenv --python=python2.7 /data/python/Klipper \
    && source /data/python/Klipper/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade pip wheel \
    && git clone https://github.com/Klipper3d/klipper.git /data/klipper \
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
COPY rootfs/data/config/klipper/printer.cfg /data/config/klipper/printer.cfg



FROM build-base AS mjpg-streamer
RUN echo "Install mjpg-streamer" \
    && apk add --no-ca \
        libjpeg-turbo-dev \
    && wget -qO- https://github.com/jacksonliam/mjpg-streamer/archive/master.tar.gz | tar xz -C /tmp \
    && cd /tmp/mjpg-streamer-master/mjpg-streamer-experimental/ \
    && make --silent \
    && make install --silent \
    && mv www/ /www_mjpg



FROM build-base AS curaengine
ARG CURA_VERSION=15.04.6
RUN apk add --no-cache libexecinfo-dev \
    && wget -qO- https://github.com/Ultimaker/CuraEngine/archive/${CURA_VERSION}.tar.gz | tar xz \
    && cd CuraEngine-${CURA_VERSION} \
    && make --silent \
    && mv build/CuraEngine /CuraEngine



FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"
ENV PATH=${PATH}:/data/python/OctoPrint/bin:/data/python/Klipper/bin

RUN echo "Install required packages for running." \
    && apk add --no-cache \
        python2 \
        python3 \
        nginx
RUN echo "Install additional packages" \
    && apk add --no-cache --virtual .extras \
        build-base \
        linux-headers \
        gphoto2 \
        ffmpeg \
        vim \
        screen

# Copy data from previous stages and do some setup.
## OctoPrint
COPY --from=octoprint /data/python/OctoPrint /data/python/OctoPrint
COPY --from=octoprint /data/config/octoprint /data/config/octoprint
RUN ln -s /data/config/octoprint $HOME/.octoprint
## Klipper
COPY --from=klipper /data/python/Klipper /data/python/Klipper
COPY --from=klipper /data/klipper /data/klipper
COPY --from=klipper /usr/local/bin/klipper_mcu /usr/local/bin/klipper_mcu
## mjpg-streamer
COPY --from=mjpg-streamer /usr/local/lib/mjpg-streamer /usr/local/lib/mjpg-streamer
COPY --from=mjpg-streamer /usr/local/share/mjpg-streamer /usr/local/share/mjpg-streamer
COPY --from=mjpg-streamer /usr/local/bin/mjpg_streamer /usr/local/bin/mjpg_streamer
COPY --from=mjpg-streamer /www_mjpg /www_mjpg
## Slicer
COPY --from=curaengine /CuraEngine /usr/local/bin/CuraEngine

COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /

# Cleanup, move files in /data to archives.
RUN echo "Cleanup and move output" \
    && find /data/python/OctoPrint | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /data/python/Klipper | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache \
    && cd /data/python && tar -zcf /root/OctoPrint-python.tar.gz OctoPrint \
    && cd /data/config && tar -zcf /root/OctoPrint-config.tar.gz octoprint \
    && cd /data/python && tar -zcf /root/Klipper-python.tar.gz Klipper \
    && cd /data && tar -zcf /root/Klipper-src.tar.gz klipper \
    && cd /data/config && tar -zcf /root/Klipper-config.tar.gz klipper \
    && rm -rf /data/*
