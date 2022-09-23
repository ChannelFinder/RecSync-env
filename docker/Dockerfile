#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  date    : Thu Sep 22 21:40:08 PDT 2022
#  version : 0.0.3

## builder : 28.4MB 
FROM alpine:3.16 AS builder
ENV WorkPath /home/RecSync-env
ARG RS_SERVER_PORT=5075
ARG RS_PORT_BROADCAST=5076
ARG RS_INSTALL_LOCATION=/opt/recsync
ARG CF_PORT_HTTP=8080
ARG RS_BIND_PORT=45722

# We can check the package availbilities through docker run -t -i --entrypoint /bin/sh alpine:3.16
RUN apk --no-cache add bash git make tree

WORKDIR $WorkPath
COPY . .
RUN echo "CF_PORT:=${CF_PORT_HTTP}" > configure/CONFIG_COMMON.local
RUN echo "RS_INSTALL_LOCATION:=${RS_INSTALL_LOCATION}" > configure/CONFIG_SITE.local
RUN make distclean && \
    make init && \
    make install.docker    

## Multi-Stages build : 124MB (buster-slim : 166MB)
FROM alpine:3.16
LABEL maintainer="Jeong Han Lee <jeonghan.lee@gmail.com>"

ARG BUILD_DATE
ARG BUILD_VERSION
ARG RS_SERVER_PORT=5075
ARG RS_PORT_BROADCAST=5076
ARG RS_INSTALL_LOCATION=/opt/recsync
ARG CF_PORT_HTTP=8080
ARG RS_BIND_PORT=45722
ARG TZ=America/Los_Angeles

# Labels.
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="alscontrols/recsync"
LABEL org.label-schema.description="EPICS RecSync Server (RecCeiver) Docker Image"
LABEL org.label-schema.url="https://github.com/ChannelFinder/RecSync-env/"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run --network=host --detach --rm --name=recsync alscontrols/recsync:latest"

### RecCeiver PORT / Installation location configuration.
ENV RS_SERVER_PORT $RS_SERVER_PORT
ENV RS_PORT_BROADCAST $RS_PORT_BROADCAST
ENV RS_INSTALL_LOCATION $RS_INSTALL_LOCATION
ENV CF_PORT_HTTP $CF_PORT_HTTP
ENV RS_BIND_PORT $RS_BIND_PORT
ENV PYTHONPATH $RS_INSTALL_LOCATION
#
#
### YOUR TIME ZONE
ENV TZ $TZ
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

### Install minimal packages for RecSync with alpine
##  Python 3.8.3-r0 in alpine 3.12, we can reduce the image size of 85.2MB, but it doesn't work due to 
##  imcompatiblities in py3-requests
##  RUN apk add --no-cache bash py3-twisted py3-simplejson py3-urllib3 py3-setuptools py3-requests
### Even if Python2, apk install a lot of Python3 packages, so we reduce the size only 43MB 
RUN apk add --no-cache bash py3-twisted py3-simplejson py3-urllib3 py3-requests py3-setuptools tzdata

WORKDIR ${RS_INSTALL_LOCATION}
COPY --from=builder $RS_INSTALL_LOCATION .
COPY --from=builder $RS_INSTALL_LOCATION/dropin.cache ./twisted/plugins/
#RUN rm -f $RS_INSTALL_LOCATION/dropin.cache
##
# CF Port : http
EXPOSE $CF_PORT_HTTP/tcp
EXPOSE $CF_PORT_HTTP/udp
# RecCeiver Broadcast Port
EXPOSE $RS_PORT_BROADCAST/udp
# RecCeiver Server Port
EXPOSE $RS_SERVER_PORT/udp
#
EXPOSE $RS_BIND_PORT/tcp
EXPOSE $RS_BIND_PORT/udp
#
COPY ./docker/scripts/entrypoint.sh /entrypoint.sh
# First run is necessary, because of the following error
# /usr/bin/twistd: The specified reactor cannot be used, failed with error: reactor already installed.
RUN /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
