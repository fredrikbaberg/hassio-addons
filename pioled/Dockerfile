ARG BUILD_FROM="homeassistant/armhf-base-python:3.10-alpine3.16"

FROM ${BUILD_FROM} AS final

RUN apk add -U \
    build-base \
    py3-pillow

RUN pip install \
    RPi.GPIO \
    adafruit-circuitpython-ssd1306

COPY rootfs/ /
 RUN chmod a+x /run.sh

 CMD [ "/run.sh "]