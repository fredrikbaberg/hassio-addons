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
ADD run.sh /home/octoprint/run.sh
ADD octoprint_run.sh /usr/local/bin/octoprint
RUN chown -R octoprint:octoprint /home/octoprint/run.sh && \
    chown -R octoprint:octoprint /home/octoprint/octoprint_run.sh && \
    chmod +x /home/octoprint/run.sh && \
    chmod +x /usr/local/bin/octoprint
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
    python3-dev \
    avahi-compat-libdns_sd \
    py2-pip \
    py-numpy \
    py3-sip \
    && \
    # The above will be uninstalled at the end, the following will not.
    sudo apk add --update --no-cache \
    python-dev \
    && \
    # Install OctoPrint
    cd /home/octoprint/ && \
    git clone https://github.com/foosel/OctoPrint.git && \
    cd /home/octoprint/OctoPrint && \
    virtualenv venv && \
    ./venv/bin/pip install pip --upgrade && \
    # Install Pybonjour issue solution: https://github.com/hauckwill/linconnect-server/issues/88
    ./venv/bin/pip install -e git+https://github.com/Eichhoernchen/pybonjour.git#egg=pybonjour && \
    ./venv/bin/python setup.py install && \
    mkdir ~/.octoprint && \
    # Cleanup after compiling octoprint
    cd /home/octoprint/OctoPrint && \
    find . -not -name 'venv' -not -name '.' -not -name '..' -maxdepth 1 -exec rm -rf {} + && \
    # Install CuraEngine dependencies
    mkdir -p /home/octoprint/Cura && \
    cd /home/octoprint/Cura && \
    git clone https://github.com/Ultimaker/libArcus.git && \
    cd libArcus && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    sudo make install && \
    # Need to use Cura <= 15.0.4, for OctoPrint integration.
    cd /home/octoprint/Cura && \
    git clone -b legacy https://github.com/Ultimaker/CuraEngine.git && \
    make -C CuraEngine && \
    # Write octoprint config
    echo "server:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "  commands:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    serverRestartCommand: sudo octoprint restart" >> /home/octoprint/.octoprint/config.yaml && \
    echo "devel:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "  virtualPrinter:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    enabled: true" >> /home/octoprint/.octoprint/config.yaml && \
    echo "plugins:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "  cura:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    cura_engine: /data/Cura/CuraEngine/build/CuraEngine" >> /home/octoprint/.octoprint/config.yaml && \
    # echo "    cura_engine: /home/octoprint/Cura/CuraEngine/build/CuraEngine" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    debug_logging: false" >> /home/octoprint/.octoprint/config.yaml && \
    # Cleanup after installing CuraEngine
    cd /home/octoprint/Cura/libArcus/build && \
    make clean && \
    cd /home/octoprint/Cura/CuraEngine && \
    find . -not -name 'build' -not -name '.' -not -name '..' -maxdepth 1 -exec rm -rf {} + && \
    # Remove packages from building
    sudo apk del build-dependencies
VOLUME /home/octoprint/Cura
VOLUME /home/octoprint/OctoPrint
EXPOSE 5000
WORKDIR /home/octoprint
ENTRYPOINT ./run.sh
# ENTRYPOINT /bin/sh
