RecCeiver-env
===
Configuration Environment for recsync server (aka. RecCeiver) at https://github.com/ChannelFinder/recsync/tree/master/server

## Role
In order to download, install, setup all relevant components, one should do many steps manually. This repository was designed for the easy-to-reproducible environment for recsyn server.

## Requirements

**Note that this implementation is valid only for recsync server.**


### python-twisted, sqlite3, and EPICS base

* Debian 10

```
sudo apt install sqlite3 python-twisted python-requests python-simplejson python-urllib3
```

## Few Makefile Rules

### `make init`
* 


### `make install`
* `sudo` permission is required.
*

### `make distclean`
*

### `make vars`
* Print out interesting variables
* One can use `make PRINT.VARIABLE_NAME` to print out them. For example,  `make PRINT.INSTALL_LOCATION`.

## A typical example to configure the ChannelFinder service

Note that this example has the assumption which ES service is running.


```
$ make init
```


## Customize site-specific configuration
Please consult two files in `configure` path, such as `RELEASE` and `CONFIG_SITE`. There are few comments on there. If you are familiar with the standard EPICS building system [1], it should be easy to understand them, because we mimic that concept into this repository. 


## Reference

[1] https://epics-controls.org/


