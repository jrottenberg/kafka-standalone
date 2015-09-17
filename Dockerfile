# Builds an image for Apache Kafka 0.8 from binary distribution.
#
# The netflixoss/java base image runs Oracle Java 7 installed atop the
# ubuntu:trusty (14.04) official image. Docker's official java images are
# OpenJDK-only currently, and the Kafka project, Confluent, and most other
# major Java projects test and recommend Oracle Java for production for optimal
# performance.
#
# Thanks to https://hub.docker.com/r/ches/kafka/ for
#
FROM netflixoss/java:8
MAINTAINER Julien Rottenberg <julien@rottenberg.info>

EXPOSE 9092 2181

# The Scala 2.10 build is currently recommended by the project.
ENV KAFKA_VERSION=0.8.2.1 KAFKA_SCALA_VERSION=2.10
ENV KAFKA_RELEASE_ARCHIVE kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz



RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates supervisor

# Download Kafka binary distribution
ADD http://www.us.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_RELEASE_ARCHIVE} /tmp/
ADD https://dist.apache.org/repos/dist/release/kafka/${KAFKA_VERSION}/${KAFKA_RELEASE_ARCHIVE}.md5 /tmp/

# Check artifact digest integrity
RUN echo VERIFY CHECKSUM: && \
  gpg --print-md MD5 /tmp/${KAFKA_RELEASE_ARCHIVE} 2>/dev/null && \
  cat /tmp/${KAFKA_RELEASE_ARCHIVE}.md5


# Install Kafka to /kafka
WORKDIR /kafka

RUN tar -zx -C /kafka --strip-components=1 -f /tmp/${KAFKA_RELEASE_ARCHIVE} && \
    rm -rf /tmp/kafka_* && mkdir -p /logs/kafka /logs/zookeeper && ln -s /logs/zookeeper /tmp/zookeeper && ln -s /logs/kafka /tmp/kafka-logs


RUN chown -R nobody: /kafka /logs

VOLUME [ "/logs" ]

# need to investigate why supervisord was not able to start kafka
# ADD  *.conf /etc/supervisor/conf.d/
# CMD ["supervisord", "--nodaemon"]
#
ADD  start.sh /start.sh

CMD ["sudo", "-u", "nobody", "/start.sh"]
