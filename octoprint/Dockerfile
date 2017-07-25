FROM %%BASE_IMAGE%%

ENV LANG C.UTF-8

# Need to have a mix of
# * hassio example
# * https://github.com/OctoPrint/docker
# * https://github.com/theorician/docker-alpine-octoprint/

LABEL maintainer "fredrik.baberg@gmail.com"

ADD setup_user.sh /root/
RUN /root/setup_user.sh

ADD setup_octoprint.sh /root/
RUN /root/setup_octoprint.sh

# ADD setup_curaengine.sh /root/
# RUN /root/setup_curaengine.sh

USER user
EXPOSE 5000
CMD /usr/bin/octoprint