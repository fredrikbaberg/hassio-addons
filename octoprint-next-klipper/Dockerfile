ARG BUILD_FROM="fredrikbaberg/addon-octoprint-next-amd64:latest"

FROM ${BUILD_FROM} AS final

RUN echo "Install dependencies." && \
    apk add --no-cache --virtual .dependencies-klipper \
        build-base \
        python3-dev \
        py3-virtualenv \
        libffi-dev \
        avrdude
    #     python2-dev && \
    #     ncurses-dev \
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
RUN echo "Get code." && \
    wget -qO- https://github.com/Doridian/klipper/archive/custom.tar.gz | tar xz -C /tmp && \
    mv /tmp/klipper-custom/ /root/klipper
RUN echo "Install." && \
    virtualenv --python=python3 /root/klippy-env && \
    source /root/klippy-env/bin/activate && \
    /root/klippy-env/bin/python -m pip install ${PIP_FLAGS} --upgrade pip && \
    # Install
    pip install ${PIP_FLAGS} -r /root/klipper/scripts/klippy-requirements.txt \
    pip install ${PIP_FLAGS} numpy && \
    # Cleanup
    find /root/klippy-env | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    rm -rf /root/.cache
COPY rootfs/ /
WORKDIR /
