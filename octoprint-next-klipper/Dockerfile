ARG BUILD_FROM="homeassistant/amd64-base:latest"

# FROM ${BUILD_FROM} AS klipper
# ENV LANG C.UTF-8
# ENV PIP_FLAGS="--no-cache-dir"
# ENV CFLAGS="-fcommon"
# ENV PYTHONPATH=/root/klipper-env
# ENV PATH=${PATH}:/root/klipper-env/bin
# ENV PYTHONUSERBASE=/root/klipper-env

# RUN echo "Install Klipper." && \
#     apk add --no-cache --virtual .build-dependencies-klipper \
#         build-base \
#         python3-dev \
#         py3-virtualenv \
#         libffi-dev \
#     #     python2-dev && \
#     #     ncurses-dev \
#     #     avrdude \
#     #     gcc-avr \
#     #     binutils-avr \
#     #     avr-libc \
#     #     freetype-dev \
#     #     fribidi-dev \
#     #     harfbuzz-dev \
#     #     jpeg-dev \
#     #     lcms2-dev \
#     #     openjpeg-dev \
#     #     tcl-dev \
#     #     tiff-dev \
#     #     tk-dev \
#     #     zlib-dev \
#     && \
#     virtualenv --python=python3 /root/klippy-env && \
#     source /root/klippy-env/bin/activate && \
#     /root/klippy-env/bin/python -m pip install ${PIP_FLAGS} --upgrade pip && \
#     wget -qO- https://github.com/Doridian/klipper/archive/custom.tar.gz | tar xz -C /tmp && \
#     mv /tmp/klipper-custom/ /root/klipper && \
#     pip install ${PIP_FLAGS} -r /root/klipper/scripts/klippy-requirements.txt
#     # cd /data && \
#     # tar -zcf /root/klippy-env.tar.gz klippy-env && \
#     # tar -zcf /root/klipper.tar.gz klipper

FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir"
ENV CFLAGS="-fcommon"
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

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
    virtualenv --python=python3 /root/klippy-env && \
    source /root/klippy-env/bin/activate && \
    /root/klippy-env/bin/python -m pip install ${PIP_FLAGS} --upgrade pip && \
    wget -qO- https://github.com/Doridian/klipper/archive/custom.tar.gz | tar xz -C /tmp && \
    mv /tmp/klipper-custom/ /root/klipper && \
    pip install ${PIP_FLAGS} -r /root/klipper/scripts/klippy-requirements.txt
    apk del --no-cache .build-dependencies-klipper

# Install requirements for running Klipper.
RUN apk add --no-cache libffi

# COPY --from=klipper /root/klippy-env/ /root/klippy-env/
# COPY --from=klipper /root/klipper/ /root/klipper/

# Copy data from filesystem and previous stages
COPY rootfs/ /
WORKDIR /
