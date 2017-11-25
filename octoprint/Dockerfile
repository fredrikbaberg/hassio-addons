# FROM %%BASE_IMAGE%%
ARG BUILD_FROM
FROM $BUILD_FROM
# FROM homeassistant/amd64-base:latest
RUN apk add --update --no-cache sudo python && \
    # Add user, and make sure to have sudo access.
    addgroup -S octoprint && \
    adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint && \
    addgroup octoprint dialout && \
    addgroup octoprint tty && \
    echo "octoprint ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER octoprint
# Make sure all files are built for the path /data. Will copy files away from there, and back when running.
# Not a nice solution, but might work.
RUN sudo mkdir -p /data && sudo chown -R octoprint:octoprint /data
WORKDIR /data
RUN sudo apk add --update --no-cache --virtual build-dependencies \
    build-base alpine-sdk git py-virtualenv python-dev linux-headers \
    avahi-compat-libdns_sd \
    cmake protobuf-dev python3-dev py3-sip-dev py3-sip \
    libexecinfo-dev \
    yaml-dev && \
    cd /data && git clone https://github.com/foosel/OctoPrint.git && \
    cd /data && git clone https://github.com/Ultimaker/libArcus.git && \
    cd /data && git clone -b legacy https://github.com/Ultimaker/CuraEngine.git && \
    # Install OctoPrint
    cd /data/OctoPrint && \
    virtualenv venv --quiet && \
    ./venv/bin/pip install -e git+https://github.com/Eichhoernchen/pybonjour.git#egg=pybonjour --quiet && \
    ./venv/bin/python setup.py install --quiet && \
    ./venv/bin/python setup.py clean --all --quiet && \
    rm -rf .git && \
    find . -not -name 'venv' -not -name '.' -not -name '..' -not -name 'run' -maxdepth 1 -exec rm -rf {} + && \
    # Install CuraEngine dependencies
    cd /data/libArcus && mkdir -p build && cd build && cmake .. && make && sudo make install && \
    cd /data/libArcus && rm -rf .git && \
    cd /data/libArcus/build && make clean && \
    # Install CuraEngine <= 15.0.4 (for OctoPrint integration).
    cd /data && make -C CuraEngine --quiet && \
    rm -rf CuraEngine/.git && \
    cd CuraEngine/ && find . -not -name 'build' -not -name '.' -not -name '..' -maxdepth 1 -exec rm -rf {} + && \
    # Setup configuration file for octoprint.
    mkdir -p /home/octoprint/.octoprint && cd /home/octoprint && \
    echo "server:" >> .octoprint/config.yaml && \
    echo "  commands:" >> .octoprint/config.yaml && \
    echo "    serverRestartCommand: /home/octoprint/octoprint.sh" >> .octoprint/config.yaml && \
    echo "devel:" >> .octoprint/config.yaml && \
    echo "  virtualPrinter:" >> .octoprint/config.yaml && \
    echo "    enabled: true" >> .octoprint/config.yaml && \
    echo "plugins:" >> .octoprint/config.yaml && \
    echo "  cura:" >> .octoprint/config.yaml && \
    echo "    cura_engine: /data/CuraEngine/build/CuraEngine" >> .octoprint/config.yaml && \
    echo "    debug_logging: false" >> .octoprint/config.yaml && \
    sudo apk del build-dependencies && \
    sudo apk add --update --no-cache --virtual run-dependencies \
    python && \
    mv /data/* /home/octoprint/
COPY octoprint.sh /home/octoprint/octoprint.sh
# Make script have correct permissions and is executable.
RUN sudo chown -R octoprint:octoprint /home/octoprint/octoprint.sh && \
    sudo chmod +x /home/octoprint/octoprint.sh
EXPOSE 5000
WORKDIR /home/octoprint
ENTRYPOINT /home/octoprint/octoprint.sh && tail -f /dev/null
