FROM %%BASE_IMAGE%%
# FROM homeassistant/amd64-base:latest
RUN apk add --update --no-cache \
    sudo && \
    # Add user, and make sure to have sudo access.
    addgroup -S octoprint && \
    adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint && \
    addgroup octoprint dialout && \
    addgroup octoprint tty && \
    echo "octoprint ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
COPY octoprint.sh /home/octoprint/
RUN chown -R octoprint:octoprint /home/octoprint/octoprint.sh && \
    chmod +x /home/octoprint/octoprint.sh
USER octoprint
# Now run all commands for pre-build, build, and cleanup, in one run (to make image smaller).
RUN sudo apk add --update --no-cache --virtual build-dependencies \
    build-base \
    alpine-sdk \
    git \
    cmake \
    linux-headers \
    yaml-dev \
    py-setuptools \
    py-virtualenv \
    protobuf-dev \
    py3-sip-dev \
    avahi \
    libexecinfo-dev \
    avahi-compat-libdns_sd \
    py2-pip \
    py-numpy \
    py3-sip \
    && \
    sudo apk add --update --no-cache --virtual run-dependencies \
    python-dev \
    python3-dev \
    && \
    # OctoPrint
    git clone https://github.com/foosel/OctoPrint.git /home/octoprint/OctoPrint && \
    cd /home/octoprint/OctoPrint && \
    virtualenv venv && \
    # ./venv/bin/pip install pip --upgrade && \
    # Install Pybonjour issue solution: https://github.com/hauckwill/linconnect-server/issues/88
    ./venv/bin/pip install -e git+https://github.com/Eichhoernchen/pybonjour.git#egg=pybonjour && \
    ./venv/bin/python setup.py install && \
    # CuraEngine
    mkdir -p /home/octoprint/Cura && \
    git clone https://github.com/Ultimaker/libArcus.git /home/octoprint/Cura/libArcus && \
    mkdir -p /home/octoprint/Cura/libArcus/build && \
    cd /home/octoprint/Cura/libArcus/build && \
    cmake .. && make && sudo make install && \
    # Need to use Cura <= 15.0.4, for OctoPrint integration.
    git clone -b legacy https://github.com/Ultimaker/CuraEngine.git /home/octoprint/Cura/CuraEngine && \
    cd /home/octoprint/Cura && \
    make -C CuraEngine && \
    # Cleanup
    cd /home/octoprint/OctoPrint && find . -not -name 'venv' -not -name '.' -not -name '..' -maxdepth 1 -exec rm -rf {} + && \
    cd /home/octoprint/Cura/CuraEngine && find . -not -name 'build' -not -name '.' -not -name '..' -maxdepth 1 -exec rm -rf {} + && \
    sudo apk del build-dependencies
    # Write octoprint config
RUN mkdir -p /home/octoprint/.octoprint && \
    echo "server:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "  commands:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    serverRestartCommand: /data/OctoPrint/venv/bin/octoprint daemon restart --config /config/octoprint/config.yaml --basedir /config/octoprint >> /home/octoprint/log_octo.txt" >> /home/octoprint/.octoprint/config.yaml && \
    echo "devel:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "  virtualPrinter:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    enabled: true" >> /home/octoprint/.octoprint/config.yaml && \
    echo "plugins:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "  cura:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    cura_engine: /data/Cura/CuraEngine/build/CuraEngine" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    debug_logging: false" >> /home/octoprint/.octoprint/config.yaml
EXPOSE 5000
WORKDIR /home/octoprint
ENTRYPOINT /home/octoprint/octoprint.sh && tail -f /dev/null
