# RecSync-env
[![Debian 11](https://github.com/jeonghanlee/RecSync-env/actions/workflows/debian11.yml/badge.svg)](https://github.com/jeonghanlee/RecSync-env/actions/workflows/debian11.yml)
[![Ubuntu latest](https://github.com/jeonghanlee/RecSync-env/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/jeonghanlee/RecSync-env/actions/workflows/ubuntu.yml)
[![Rocky8](https://github.com/jeonghanlee/RecSync-env/actions/workflows/rocky8.yml/badge.svg)](https://github.com/jeonghanlee/RecSync-env/actions/workflows/rocky8.yml)
[![Linter Run](https://github.com/jeonghanlee/RecSync-env/actions/workflows/linter.yml/badge.svg)](https://github.com/jeonghanlee/RecSync-env/actions/workflows/linter.yml)
[![Docker](https://github.com/jeonghanlee/RecSync-env/actions/workflows/docker.yml/badge.svg)](https://github.com/jeonghanlee/RecSync-env/actions/workflows/docker.yml)
Configuration Environment for the recsync server (aka. RecCeiver) at <https://github.com/ChannelFinder/recsync/tree/master/server>

## Pre-required Packages

```
git make sudo tree 
```

## macOS

We only support macOS for testing and developing purposes, so we don't have launchd configuration. We localize the recsync service within a local folder, and define several simple Makefile rules to maintain them.
To use the following rules, one need to setup `homebrew` first. 

* Install Python3 and its required packages through `pip3`

```bash
make install.p3mac
```

* Installation and running procedures

```
make init
make conf
make conf.show
make local.install
make exist
make local.run
make local.stop
```

The log file will be located in `RS_INSTALL_LOCATION`, e.g., `$(TOP)/recsync.local` folder.


```
make local.rm
```

## Docker Image

See [docs/Docker.md](docs/Docker.md) :whale:

## While evaluating its configuration

Modify any configuration files, and then run the following command:

```bash
make restart
sudo systemctl start recsync.service
systemctl status recsync.service
```

## Reference

[1] <https://github.com/ChannelFinder/pyCFClient>

[2] <https://github.com/ChannelFinder/recsync>

[3] <https://epics-controls.org>
