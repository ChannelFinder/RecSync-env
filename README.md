RecSync-env
===
Configuration Environment for the recsync server (aka. RecCeiver) at https://github.com/ChannelFinder/recsync/tree/master/server

## Role
In order to download, install, setup all relevant components, one should do many steps manually. This repository was designed for the easy-to-reproducible environment for recsync server (aka RecCeiver).


## Requirements 
* ChannelFinder : Please check it https://github.com/ChannelFinder/ChannelFinder-env 
* systemd service : this repository has its own systemd configuration. 
* `SUDO` permission
* Few system packages : Please see below. We **will** use the system default python packages and system package manager (e.g., apt for Debian) instead of `conda`, `pip`, or whatever python tools, because we would like to install `RecCeiver` in a specific local directory instead of any Python related paths. This approach gives users, who may not be familiar with many Python environments, to focus only `RecCeiver`. I am sure that users should learn million different and continuous evolving Python environments later if one would like to use it within them.  
* pyCFClient : In order to integrate `RecCeiver` with ChannelFinder, pyCFClient Python application [1] or package is required. The repository [1] was already integrated into the current repository. Thus one doesn't need to care about it. 

### system packages
	Note that `sqlite3` may not be necessary if one would like to test it with ChannelFinder directly.

* Debian 10

```
sudo apt install sqlite3 python-twisted python-requests python-simplejson python-urllib3
```

* CentOS 7
```
sudo yum install sqlite  python-twisted-web python-requests python2-simplejson python-urllib3
```
 
* CentOS 8

* Fedora 31


## Few Makefile Rules

### `make`
* Print out selected rules with a little explanation

### `make init`
* Download recsync [2] and pyCFClient [1]
* Switch to specific versions defined as `$(SRC1_TAG)` for recsync and `$(SRC2_TAG)` for pyCFClinet in `configure/RELEASE`

### `make install`
* `sudo` permission is required.
* Add a user `recceiver` and a group id `65534` into a host system. Note that `nogroup` is valid only for Debian.
* Copy all files in `recsync/server` and `pyCFClient` into defined a local installation path `INSTALL_LOCATION` in `configure/RELEASE`
* Setup and enable systemd service

### `make distclean`
* Remove the downloaded recsync [2] and pyCFClient [1] source files. 

### `make vars`
* Print out interesting variables
* One can use `make PRINT.VARIABLE_NAME` to print out them. For example,  `make PRINT.INSTALL_LOCATION`.

## A typical example to configure the ChannelFinder service

Note that this example has the assumption which ES service is running.


```
$ make init
$ make install
$ sudo systemctl start recsync.service
$ systemctl status recsync.service
```


## Customize site-specific configuration
Please consult two files in `configure` path, such as `RELEASE` and `CONFIG_SITE`. There are few comments on there. If you are familiar with the standard EPICS building system [3], it should be easy to understand them, because we mimic that concept into this repository. 

## While evaluating its configuration

Modify any configuration files, and then run the following command:

```
$ make restart
$ sudo systemctl start recsync.service
$ systemctl status recsync.service
```

## Notice

* If one installs this at the first time, or reinstall from scratch, for example, `make restart`, one has to start its systemd service one more time, because of the issue mentioned in https://github.com/ChannelFinder/recsync/issues/37

* There are two important configuration files, which are configured carefully. One is `site-template/recsync.conf.in` and the other is `site-template/channelfinderapi.conf`. Especially, one should use the same and correct information in `channelfinderapi.conf` in order to match with its ChannelFinder configuration. For example, user name and its password should be matched with https://github.com/ChannelFinder/ChannelFinder-env/blob/master/site-template/cf4als.ldif. 

## Reference

[1] https://github.com/ChannelFinder/pyCFClient

[2] https://github.com/ChannelFinder/recsync

[3] https://epics-controls.org/


