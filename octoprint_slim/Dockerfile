ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

ENV OCTOPRINT_VERSION=1.3.11
# To have Python packages persistently installed.
ENV PYTHONPATH=/data/python
ENV PATH=${PATH}:/data/python/bin
ENV PYTHONUSERBASE=/data/python

# Change to tmp folder for all installs, easier to clean
WORKDIR /tmp

# Install requirements for add-on
RUN apk add --no-cache jq supervisor py-pip \
    && \
    # Get code for installation, install.
    wget -qO- https://github.com/foosel/OctoPrint/archive/${OCTOPRINT_VERSION}.tar.gz | tar xz \
    && \
    # Compile and install
    apk add --no-cache --virtual build-dependencies \
    build-base python-dev linux-headers \
    && \
    # Octoprint
    apk add --no-cache avahi-compat-libdns_sd \
    && cd /tmp/OctoPrint-${OCTOPRINT_VERSION} \
    && pip install --upgrade pip --user \
    && pip install -r requirements.txt --user \
    && python setup.py install --user \
    && cp -R /data/python /root/ \
    && \
    # Cleanup
    apk del --no-cache build-dependencies \
    && rm -rf /tmp

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 5000
WORKDIR /
CMD [ "/run.sh" ]
