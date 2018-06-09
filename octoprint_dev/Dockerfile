ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install requirements
RUN apk add --update --no-cache sudo tini
RUN addgroup -S octoprint && \
    adduser -G octoprint -g "octoprint user" -s /bin/sh -D octoprint && \
    echo "octoprint ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER octoprint

# Setup and install.
RUN sudo mkdir -p /data && sudo chown -R octoprint:octoprint /data
WORKDIR /data
RUN sudo apk add --update --no-cache \
    git

# Copy data for add-on
COPY --chown=octoprint:octoprint run.sh /run.sh
RUN ["chmod", "a+x", "/run.sh"]
CMD ["tini", "-s", "--", "/run.sh"]
