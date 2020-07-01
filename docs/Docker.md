RecSync Server (aka RecCeiver) Docker image
===

## User should be in the docker group

```
sudo groupadd docker
sudo usermod -aG docker ${USER}
```
Note that one will have to log out and to log in to take effect! One should look at two references [1,2] to understand security issues.


## Pull the release image from a registry (hub.docker.com)

```
docker pull jeonghanlee/recsync:1-v0.1.0
```


## Run

* Run with console outputs
```
docker run --network=host --rm --name=recceiver  jeonghanlee/recsync:1-v0.1.0
```

* Run in the detach mode
```
docker run --network=host -d --rm --name=recceiver  jeonghanlee/recsync:1-v0.1.0
```

* Run in order to access the container without the recsync service
```
docker run --network=host -i -t --entrypoint /bin/bash jeonghanlee/recsync:1-v0.1.0
```

* Run with the local disk mount
```
docker run -i -t -v ${HOME}/docker_data:/data --entrypoint /bin/bash jeonghanlee/recsync:1-v0.1.0
```
, where `${HOME}/docker_data` is the host path, which will be created if it doesn't exist, and `/data` is a volume in the docker container.


## Status, Stop, and restart

* Check the channelfinder service is running

```
docker ps -f name=recceiver
```

* Check the service logs
```
docker logs recceiver
```

* Stop the service
```
docker stop recceiver
```

* Restart the service
```
docker start recceiver
```

* Remove the channelfinder
```
docker rm -f recceiver
```

* Remove all leftover containers
```
docker rm $(docker ps -aq)
```

## Building the Docker image

* Clone
```
$ git clone https://github.com/jeonghanlee/RecSync-env
```

* Configure desired RecSync configuration

I assume that ES and CF service stays in the same Docker host where RecSync container.

* Default the build with the docker
```
$ make build.docker
.....
Removing intermediate container 09d8f45a3b6e
 ---> 141a4f1458e9
Successfully built 141a4f1458e9
Successfully tagged jeonghanlee/recsync:2006302234

```
The following error message one can ignore due to twistd issue. The next docker run will resolve it automatically.
```
/usr/bin/twistd: The specified reactor cannot be used, failed with error: reactor already installed.
```



## References
[1] https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface

[2] https://docs.docker.com/engine/security/rootless/
