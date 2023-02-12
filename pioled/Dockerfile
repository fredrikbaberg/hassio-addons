ARG BUILD_FROM="homeassistant/armhf-base-python:3.10-alpine3.16"

FROM ${BUILD_FROM} AS final

RUN apk add -U \
    py3-rpigpio \
    py3-pillow

COPY rootfs/ /
WORKDIR /
