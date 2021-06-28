ARG BUILD_FROM="homeassistant/armhf-base-raspbian"

# Get Fluidd source
FROM ${BUILD_FROM} AS fluidd
WORKDIR /frontend
ARG DEBIAN_FRONTEND=noninteractive
ADD https://github.com/cadriel/fluidd/releases/latest/download/fluidd.zip /tmp/frontend.zip
RUN apt update && apt install -y unzip
RUN unzip /tmp/frontend.zip -d /frontend

# Prepare for Klipper
FROM ${BUILD_FROM} AS klipper
ENV PIP_FLAGS="--no-cache-dir"
ENV CFLAGS="-fcommon"
WORKDIR /root
ARG DEBIAN_FRONTEND=noninteractive
ADD https://github.com/KevinOConnor/klipper/archive/refs/heads/master.zip /tmp/klipper.zip
COPY rootfs/root/klipper/.config /root/klipper/.config
RUN apt update && \
    apt install -y \
    unzip \
    virtualenv \
    python2-dev \
    libffi-dev \
    build-essential \
    libncurses-dev \
    libusb-dev \
    avrdude \
    gcc-avr \
    binutils-avr \
    avr-libc \
    stm32flash \
    libnewlib-arm-none-eabi \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    libusb-1.0
RUN unzip /tmp/klipper.zip -d /tmp/klipper
RUN mv /tmp/klipper/klipper-master/* /root/klipper
RUN virtualenv --python=python2.7 /root/klippy-env && \
    source /root/klippy-env/bin/activate && \
    /root/klippy-env/bin/python -m pip install ${PIP_FLAGS} --upgrade pip && \
    pip install ${PIP_FLAGS} -r /root/klipper/scripts/klippy-requirements.txt && \
    pip install ${PIP_FLAGS} numpy
RUN echo "Compile for Linux MCU" && \
    cd /root/klipper && \
    make && \
    /root/klipper/scripts/flash-linux.sh
RUN echo "Cleanup Python env" && \
    find /root/klippy-env | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf


FROM ${BUILD_FROM} AS final

# Install Caddy as proxy server
ADD https://github.com/caddyserver/caddy/releases/download/v2.4.3/caddy_2.4.3_linux_armv7.deb /tmp/
# Install Caddy
RUN dpkg -i /tmp/caddy_2.4.3_linux_armv7.deb && rm -rf /tmp/caddy_*.deb

# Copy files related to frontend (Fluidd)
COPY --from=fluidd /frontend /frontend
# Copy files related to Klipper
COPY --from=klipper /root/klipper /root/klipper
COPY --from=klipper /root/klippy-env /root/klippy-env
COPY --from=klipper /usr/local/bin/klipper_mcu /usr/local/bin/klipper_mcu
COPY rootfs/ /


WORKDIR /root



# Install packages required for running
RUN apt update && apt install -y \
    python2-minimal \
    gcc \
    avrdude \
    binutils-avr \
    avr-libc \
    stm32flash \
    binutils-arm-none-eabi \
    libusb-1.0 && \
    rm -rf /var/lib/apt/lists/*
