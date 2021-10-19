ARG BUILD_FROM

FROM ${BUILD_FROM} AS build-base
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir --extra-index-url https://www.piwheels.org/simple"
ENV CFLAGS="-fcommon"

RUN apk add --no-cache --virtual .build \
        git \
        python3-dev \
        python2-dev \
        py3-virtualenv \
        build-base \
        linux-headers \
        cmake



FROM build-base AS mjpg-streamer
RUN echo "Install mjpg-streamer" \
    && apk add --no-cache \
        libjpeg-turbo-dev \
    && git clone --depth 1 https://github.com/jacksonliam/mjpg-streamer \
    && cd mjpg-streamer/mjpg-streamer-experimental/ \
    && make --silent \
    && make install --silent \
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



FROM build-base AS klipper
ENV PYTHONPATH=/data/python/Klipper
ENV PYTHONUSERBASE=/data/python/Klipper
ENV PATH=${PATH}:/data/python/Klipper/bin

RUN echo "Install Klipper" \
    && apk add --no-cache \
        libffi-dev \
        freetype-dev \
        libpng-dev \
    && virtualenv --python=python2.7 /data/python/Klipper \
    && source /data/python/Klipper/bin/activate \
    && pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel \
    && git clone --depth 1 https://github.com/Klipper3d/klipper.git /data/klipper \
    && pip install ${PIP_FLAGS} -r /data/klipper/scripts/klippy-requirements.txt \
    && pip install ${PIP_FLAGS} --upgrade \
        numpy \
    && find /data/python/Klipper | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache
# Need to make two changes to /data/klipper/src/linux/main.c due to sched_setscheduler not being available in Alpine:
# - Add #include<pthread.h>
# - Replace sched_setscheduler(0, SCHED_FIFO, &sp); with pthread_setschedparam(pthread_self(), SCHED_FIFO, &sp);
RUN sed -i 's"// sched_main"// sched_main\n#include <pthread.h>"' /data/klipper/src/linux/main.c
RUN sed -i 's/sched_setscheduler(0/pthread_setschedparam(pthread_self()/' /data/klipper/src/linux/main.c
COPY rootfs/root/klipper/.config /data/klipper/.config
RUN cd /data/klipper \
    && make clean \
    && make \
    && ./scripts/flash-linux.sh \
    && make clean
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/root \
    && cd /data && tar -zcf /copy/root/Klipper-src.tar.gz klipper \
    && cd /data/python && tar -zcf /copy/root/Klipper-python.tar.gz Klipper \
    && mkdir -p /copy/usr/local/bin \
    && cp /usr/local/bin/klipper_mcu /copy/usr/local/bin/klipper_mcu



FROM build-base AS curaengine
ARG CURA_VERSION=15.04.6
RUN echo "Install CuraEngine" \
    && apk add --no-cache libexecinfo-dev \
    && git clone -b ${CURA_VERSION} --depth 1 https://github.com/Ultimaker/CuraEngine \
    && cd CuraEngine \
    && make --silent \
    && mv build/CuraEngine /usr/local/bin/CuraEngine
RUN echo "Copy files to single folder" \
    && mkdir -p /copy/usr/local/bin/ \
    && cp /usr/local/bin/CuraEngine /copy/usr/local/bin/CuraEngineLegacy



FROM ${BUILD_FROM} AS final
ENV PATH=${PATH}:/data/python/Klipper/bin

RUN echo "Install required packages for running." \
    && apk add --no-cache \
        python2
# RUN echo "Install additional packages" \
#     && apk add --no-cache \
#         ffmpeg \
#         gphoto2 \
#         libjpeg-turbo \
#         zlib \
#         build-base \
#         linux-headers \
#         vim \
#         git \
#         avrdude \
#         stm32flash

# Copy data from previous stages
# ## mjpg-streamer
COPY --from=mjpg-streamer /copy /
# ## Klipper
COPY --from=klipper /copy /
# ## CuraEngineLegacy
COPY --from=curaengine /copy /

COPY rootfs/ /
RUN chmod a+x /scripts/*.sh
WORKDIR /
