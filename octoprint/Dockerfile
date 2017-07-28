FROM %%BASE_IMAGE%%
# FROM alpine
# FROM homeassistant/amd64-base:latest
# LABEL io.hass.version="0.1"
RUN apk update
# Needed for compiling octoprint.
RUN apk add \
    build-base \
    alpine-sdk \
    git \
    py2-pip \
    python-dev \
    py-setuptools \
    py-virtualenv \
    yaml-dev \
    linux-headers \
    tree
RUN addgroup -S octoprint
RUN adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint
RUN echo "octoprint ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN cd /home/octoprint/ && \
    git clone https://github.com/foosel/OctoPrint.git
RUN chown -R octoprint:octoprint /home/octoprint/OctoPrint
USER octoprint
WORKDIR /home/octoprint/OctoPrint
RUN virtualenv venv && \
    ./venv/bin/pip install pip --upgrade && \
    ./venv/bin/python setup.py install
RUN mkdir ~/.octoprint
# Install CURA
RUN sudo apk add \
    python3-dev \
    py-numpy \
    protobuf-dev \
    py3-sip \
    py3-sip-dev \
    cmake
RUN mkdir /home/octoprint/Cura
WORKDIR /home/octoprint/Cura
# Install libArcus (required for CuraEngine).
RUN git clone https://github.com/Ultimaker/libArcus.git
RUN cd libArcus && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    sudo make install
# Install CuraEngine
RUN sudo apk add \
    libexecinfo-dev
WORKDIR /home/octoprint/Cura
## Need to use Cura <= 15.0.4, for OctoPrint to work.
# RUN git clone https://github.com/Ultimaker/CuraEngine.git
# RUN cd CuraEngine && \
#     mkdir build && \
#     cd build && \
#     cmake .. && \
#     make && \
#     cd .. && \
#     cmake . -G "CodeBlocks - Unix Makefiles"
# Create volumes, so this does not have to be done again.
RUN git clone -b legacy https://github.com/Ultimaker/CuraEngine.git
RUN make -C CuraEngine
VOLUME /home/octoprint/Cura
VOLUME /home/octoprint/OctoPrint
RUN echo "plugins:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "  cura:" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    # path to the CuraEngine <= 15.04 binary to use" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    cura_engine: /home/octoprint/Cura/CuraEngine/build/CuraEngine" >> /home/octoprint/.octoprint/config.yaml && \
    echo "" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    # whether to log the slicing output to plugin_cura_engine.log" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    debug_logging: false" >> /home/octoprint/.octoprint/config.yaml && \
    echo "" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    # identifier of the default profile to use for slicing" >> /home/octoprint/.octoprint/config.yaml && \
    echo "    default_profile: some_profile" >> /home/octoprint/.octoprint/config.yaml
WORKDIR /home/octoprint
ADD run.sh ./
RUN sudo chown -R octoprint:octoprint run.sh
RUN chmod +x run.sh
ENTRYPOINT ./run.sh
