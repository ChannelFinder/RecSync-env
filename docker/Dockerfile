#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  date    : Wednesday, July  1 15:39:00 PDT 2020
#  version : 0.0.2

##
FROM debian:buster-slim AS builder
ENV WorkPath /home/RecSyn-env

ARG RS_SERVER_PORT=5075
ARG RS_PORT_BROADCAST=5076
ARG RS_INSTALL_LOCATION=/opt/recsync
ARG CF_PORT_HTTP=8080
ARG RS_BIND_PORT=45722

RUN apt update
RUN apt install -y \
        make \
	git

WORKDIR $WorkPath
COPY . .
RUN echo "CF_PORT:=${CF_PORT_HTTP}" > configure/CONFIG_COMMON.local
RUN echo "RS_INSTALL_LOCATION:=${RS_INSTALL_LOCATION}" > configure/CONFIG_SITE.local
RUN rm -rf ${RS_INSTALL_LOCATION}
RUN make distclean && \
    make init && \
    make vars && \
    make install.docker


## Multi-Stages build
FROM debian:buster-slim
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
LABEL org.label-schema.name="jeonghanlee/recsync"
LABEL org.label-schema.description="EPICS RecSync Server (RecCeiver) Docker Image"
LABEL org.label-schema.url="https://github.com/ChannelFinder/RecSync-env/"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run --network=host --detach --rm --name=recsync jeonghanlee/recsync:tagname"

### RecCeiver PORT / Installation location configuration.
ENV RS_SERVER_PORT ${RS_SERVER_PORT}
ENV RS_PORT_BROADCAST ${RS_PORT_BROADCAST}
ENV RS_INSTALL_LOCATION ${RS_INSTALL_LOCATION}
ENV CF_PORT_HTTP ${CF_PORT_HTTP}
ENV RS_BIND_PORT ${RS_BIND_PORT}
ENV PYTHONPATH ${RS_INSTALL_LOCATION}
#
#
### YOUR TIME ZONE
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
### Reconfigure tzdata
RUN dpkg-reconfigure -f noninteractive tzdata
### Install minimal packages for RecSync
RUN apt update && apt install -y python-twisted python-requests python-simplejson python-urllib3 nano


WORKDIR ${RS_INSTALL_LOCATION}
COPY --from=builder ${RS_INSTALL_LOCATION} .
COPY --from=builder ${RS_INSTALL_LOCATION}/dropin.cache ./twisted/plugins/
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

