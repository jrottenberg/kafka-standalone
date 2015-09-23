#!/bin/bash

sudo -u nobody -E bin/zookeeper-server-start.sh -daemon config/zookeeper.properties

if [[ -n ${ADVERTISED_HOSTNAME} ]]; then
  echo "advertised.host.name=${ADVERTISED_HOSTNAME}" | tee -a  config/server.properties
fi

sudo -u nobody -E  bin/kafka-server-start.sh -daemon config/server.properties



if [[ -n ${TOPIC} ]]; then
  while netstat -lnt | awk '$4 ~ /::9092/ {exit 1}';do
    sleep 1
  done

  bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic ${TOPIC}
fi




tail -f logs/*
