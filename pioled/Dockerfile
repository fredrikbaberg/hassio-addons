ARG BUILD_FROM="homeassistant/armhf-base-python:3.10-alpine3.16"

FROM ${BUILD_FROM} AS final

RUN apk add -U \
    build-base \
    py3-pillow \
    # Pillow
    # tiff-dev \
    jpeg-dev \
    # openjpeg-dev \
    zlib-dev
    # freetype-dev \
    # lcms2-dev \
    # libwebp-dev \
    # tcl-dev \
    # tk-dev \
    # harfbuzz-dev \
    # fribidi-dev \
    # libimagequant-dev \
    # libxcb-dev \
    # libpng-dev

RUN pip install \
    RPi.GPIO \
    adafruit-circuitpython-ssd1306 \
    Pillow

COPY rootfs/ /
RUN chmod a+x /run.sh

 CMD [ "/run.sh"]