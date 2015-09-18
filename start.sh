#!/bin/bash


bin/zookeeper-server-start.sh -daemon config/zookeeper.properties


bin/kafka-server-start.sh -daemon config/server.properties


if [[ -n ${TOPIC} ]]; then

  while ! netstat -antup | grep :::9092;do
    sleep 5
  done

  sleep 10
  bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ${TOPIC}
fi


tail -f logs/*
