ARG BUILD_FROM="fredrikbaberg/addon-octoprint-next-amd64:latest"

FROM ${BUILD_FROM} AS octoklipper

RUN echo "Extract Python install" && \
    tar -zxf /root/python.tar.gz -C /data/ && \
    rm -rf /root/python.tar.gz && \
    echo "Add OctoKlipper" && \
    pip install ${PIP_FLAGS} "https://github.com/thelastWallE/OctoprintKlipperPlugin/archive/master.zip" && \
    echo "Cleanup and archive" && \
    find /data/python | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    rm -rf /root/.cache && \
    cd /data && tar -zcf /root/python.tar.gz python && \
    rm -rf /data/python

FROM ${BUILD_FROM} AS final

RUN echo "Install build dependencies." && \
    apk add --no-cache --virtual .build-dependencies-klipper \
        build-base \
        python2-dev \
        python3-dev \
        py3-virtualenv \
        libffi-dev \
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
    && \
    echo "Install run dependencies." && \
    apk add --no-cache --virtual .run-dependencies-klipper \
        python2 \
        libffi \
        avrdude \
    && \
    echo "Get code." && \
    # wget -qO- https://github.com/Doridian/klipper/archive/custom.tar.gz | tar xz -C /tmp && \
    # mv /tmp/klipper-custom/ /root/klipper && \
    wget -qO- https://github.com/KevinOConnor/klipper/archive/master.tar.gz | tar xz -C /tmp && \
    mv /tmp/klipper-master/ /root/klipper && \
    echo "Setup virtual environment." && \
    # virtualenv --python=python3 /root/klippy-env && \
    virtualenv --python=python2.7 /root/klippy-env && \
    source /root/klippy-env/bin/activate && \
    /root/klippy-env/bin/python -m pip install ${PIP_FLAGS} --upgrade pip && \
    echo "Install Klipper" && \
    pip install ${PIP_FLAGS} -r /root/klipper/scripts/klippy-requirements.txt \
    pip install ${PIP_FLAGS} numpy && \
    echo "Final cleanup" && \
    apk del --no-cache .build-dependencies-klipper && \
    find /root/klippy-env | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    rm -rf /root/.cache
COPY --from=octoklipper /root/python.tar.gz /root/python.tar.gz
COPY rootfs/ /
WORKDIR /
