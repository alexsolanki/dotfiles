#!/bin/bash
#
# This file is managed by puppet.
#
# This file defines global environment variables for Kafka Brokers.

DAEMON_USER="kafka"
INSTALL_DIR="/usr/local/kafka"
CONFIG_DIR="/etc/kafka"

# Runtime essentials.
export JAVA_HOME="$( readlink -f "$( which java )" | sed "s:/bin/.*$::" )"
export JMX_PORT="9999"
export LOG_DIR="/var/log/kafka"

# Java options.
export KAFKA_HEAP_OPTS="-Xms4G -Xmx4G"
export KAFKA_JVM_PERFORMANCE_OPTS="-server -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 \
  -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark \
  -XX:+DisableExplicitGC -XX:+UseStringDeduplication \
  -XX:+UseNUMA -Djava.awt.headless=true"
export KAFKA_LOG4J_OPTS=" \
  -Dlog4j.configuration=file:${CONFIG_DIR}/log4j.properties"
