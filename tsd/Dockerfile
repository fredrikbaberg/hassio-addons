ARG BUILD_FROM="homeassistant/amd64-base-debian:latest"

FROM ${BUILD_FROM} as source
RUN apt update && \
    apt install --no-install-recommends -y git && \
    git clone https://github.com/TheSpaghettiDetective/TheSpaghettiDetective

FROM ${BUILD_FROM} as final
ENV PIP_FLAGS="--no-cache-dir"
ENV LANG C.UTF-8

# Preparations
RUN apt update && \
    apt install --no-install-recommends -y python3-pip python3-setuptools git && \
    apt install --no-install-recommends -y libsm6 libxrender1 libfontconfig1 ffmpeg wget && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 && \
    pip install ${PIP_FLAGS} --upgrade pip wheel
# Copy source code
COPY --from=source /TheSpaghettiDetective/ml_api /app
COPY --from=source /TheSpaghettiDetective/web /web
# Install requirements
RUN pip install ${PIP_FLAGS} -r /app/requirements_x86_64.txt && \
    pip install ${PIP_FLAGS} -r /web/requirements.txt
# To mitigate some warnings
RUN pip install ${PIP_FLAGS} -U \
    psycopg2-binary \
    Twisted[tls,http2]
# Required for running
RUN apt update && \
    apt install -y \
    redis \
    tinyproxy && \
    rm -rf /var/lib/apt/lists/*
# Cleanup
RUN find /usr/lib/python* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf && \
    rm -rf /root/.cache && \
    apt remove -y python3-pip python3-setuptools git
# Copy data from filesystem
COPY rootfs/ /
