ARG BUILD_FROM="homeassistant/amd64-base-debian:latest"

FROM ${BUILD_FROM} as final

ENV LANG C.UTF-8
ENV PIP_FLAGS="--no-cache-dir"
ENV CFLAGS="-fcommon"

# Preparations
RUN apt update && \
    # Only needed for install
    apt install --no-install-recommends -y \
        python3-pip \
        python3-setuptools \
        python3-dev \
        git \
        gcc \
        libpq-dev \
        && \
    # Needed to run TSD
    apt install --no-install-recommends -y \
        libsm6 \
        libxrender1 \
        libfontconfig1 \
        ffmpeg \
        && \
    # Other packages required to run
    apt install -y \
        redis \
        nginx \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 && \
    pip install ${PIP_FLAGS} --upgrade \
        pip \
        wheel

# Get source code
WORKDIR /tmp
RUN git clone https://github.com/TheSpaghettiDetective/TheSpaghettiDetective && \
    mv TheSpaghettiDetective/ml_api /app && \
    mv TheSpaghettiDetective/web /web && \
    rm -rf TheSpaghettiDetective

# Install packages
RUN pip install ${PIP_FLAGS} --upgrade \
    Twisted[tls,http2]
    # psycopg2-binary

# Install TSD
RUN pip install ${PIP_FLAGS} -r /app/requirements_x86_64.txt
RUN pip install ${PIP_FLAGS} -r /web/requirements.txt

# Cleanup
RUN find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    rm -rf /root/.cache && \
    rm -rf /var/lib/apt/lists/* && \
    apt remove -y \
        python3-pip \
        python3-setuptools \
        python3-dev \
        git \
        gcc \
        libpq-dev

# Copy data from filesystem
COPY rootfs/ /
