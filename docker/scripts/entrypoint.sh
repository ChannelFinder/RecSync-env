#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  date    : Tuesday, June 30 18:12:00 PDT 2020
#  version : 0.0.1


## RS_INSTALL_LOCATION is defined in Docker environment variable
## entrypoint.sh is located in /
##
cd "${RS_INSTALL_LOCATION}"

command="twistd --rundir . --pidfile= --reactor=poll --nodaemon recceiver -f ./recsync.conf"
eval "$command"
