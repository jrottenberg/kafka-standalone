Kafka standalone
================

Based on [Kafka docker](https://hub.docker.com/r/ches/kafka/).

Intent
------

Intent was to keep it as simple as possible, just to let developer easily interact with kafka without the need to run docker-compose.

It's not following docker best practices (one service per container), but it allow to get you up and running with one container.

### Passing topic

You can pass a topic at container creation by passing the environment variable TOPIC

```
docker run -it -e TOPIC=mine jrottenberg/kafka-standalone
```

### Passing advertised host name

You can specify the passing the environment variable TOPIC

```
docker run -d -e ADVERTISED_HOSTNAME=$(hostname -f) -p 8092:8092 -p 2181:2181 jrottenberg/kafka-standalone
```

Production use
--------------

Just don't ;-)
