ARG BUILD_FROM="homeassistant/amd64-base:latest"

FROM ${BUILD_FROM} AS final
ENV LANG C.UTF-8
# Install requirements to run
RUN apk add --no-cache iperf3

ENTRYPOINT [ "iperf3" ]
CMD [ "-s" ]
