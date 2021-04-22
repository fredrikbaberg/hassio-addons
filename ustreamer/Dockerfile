ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} AS build

ENV LANG C.UTF-8

WORKDIR /tmp
RUN echo "Install base requirements." && \
    apk add --no-cache --virtual .build-dependencies \
        make \
        build-base \
        linux-headers \
        libjpeg-turbo-dev \
        libevent-dev \
        libbsd-dev && \
    wget -qO- https://github.com/pikvm/ustreamer/archive/master.tar.gz | tar xz && \
    cd ustreamer-master && \
    WITH_PTHREAD_NP=0 WITH_OMX=0 WITH_GPIO=0 make --silent && \
    make install

FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8

RUN apk add --no-cache --virtual .necessary-ustreamer \
    tinyproxy \
    libjpeg \
    libevent \
    libbsd
COPY --from=build /usr/local/bin/ustreamer /usr/local/bin/ustreamer

COPY rootfs/ /
WORKDIR /
