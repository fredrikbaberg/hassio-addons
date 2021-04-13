ARG BUILD_FROM="homeassistant/amd64-base-debian:latest"

FROM ${BUILD_FROM} as final

ENV PIP_FLAGS="--no-cache-dir"
ENV LANG C.UTF-8

RUN mkdir -p /tsd
WORKDIR /tsd
# Install base requirements
RUN apt update \
    # For installing
    && apt install --no-install-recommends -y python3-pip python3-setuptools git \
    # For running
    && apt install --no-install-recommends -y libsm6 libxrender1 libfontconfig1 ffmpeg wget tinyproxy redis \
    # Setup and cleanup
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 \
    && pip install ${PIP_FLAGS} --upgrade pip \
    # Get and install source
    && git clone https://github.com/TheSpaghettiDetective/TheSpaghettiDetective \
    # Install ml_api requirements
    && pip install ${PIP_FLAGS} -r TheSpaghettiDetective/ml_api/requirements_x86_64.txt \
    # Install web requirements
    && pip install ${PIP_FLAGS} -r TheSpaghettiDetective/web/requirements.txt \
    # To mitigate some warnings
    && pip install ${PIP_FLAGS} psycopg2-binary \
    # Cleanup Python files
    && find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf \
    && rm -rf /root/.cache
# Copy data from filesystem
COPY rootfs/ /
