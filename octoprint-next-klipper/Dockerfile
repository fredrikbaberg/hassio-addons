ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} AS klipper
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir"
ENV CFLAGS="-fcommon"
ENV PYTHONPATH=/data/klipper-env
ENV PATH=${PATH}:/data/klipper-env/bin
ENV PYTHONUSERBASE=/data/klipper-env

RUN echo "Install Klipper." && \
    apk add --no-cache --virtual .build-dependencies-klipper \
        build-base \
        python3-dev \
        py3-virtualenv \
        libffi-dev \
    #     python2-dev && \
    #     ncurses-dev \
    #     avrdude \
    #     gcc-avr \
    #     binutils-avr \
    #     avr-libc \
    #     freetype-dev \
    #     fribidi-dev \
    #     harfbuzz-dev \
    #     jpeg-dev \
    #     lcms2-dev \
    #     openjpeg-dev \
    #     tcl-dev \
    #     tiff-dev \
    #     tk-dev \
    #     zlib-dev \
    && \
    virtualenv --python=python3 /data/klippy-env && \
    source /data/klippy-env/bin/activate && \
    /data/klippy-env/bin/python -m pip install ${PIP_FLAGS} --upgrade pip && \
    wget -qO- https://github.com/Doridian/klipper/archive/custom.tar.gz | tar xz -C /tmp && \
    mv /tmp/klipper-custom/ /data/klipper && \
    pip install ${PIP_FLAGS} -r /data/klipper/scripts/klippy-requirements.txt && \
    cd /data && \
    tar -zcf /root/klippy-env.tar.gz klippy-env && \
    tar -zcf /root/klipper.tar.gz klipper

FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir"
ENV CFLAGS="-fcommon"
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

COPY --from=klipper /root/klippy-env.tar.gz /root/klippy-env.tar.gz
COPY --from=klipper /root/klipper.tar.gz /root/klipper.tar.gz

# Copy data from filesystem and previous stages
COPY rootfs/ /
WORKDIR /
