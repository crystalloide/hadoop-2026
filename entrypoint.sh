#!/bin/bash

# Formatage auto
if [ ! -d "/hadoop/dfs/name/current" ]; then
  $HADOOP_HOME/bin/hdfs namenode -format -force
fi

# Lancement des démons
if [ "$(hostname)" = "namenode" ]; then
  $HADOOP_HOME/bin/hdfs --daemon start namenode
  $HADOOP_HOME/bin/hdfs --daemon start datanode
  $HADOOP_HOME/bin/yarn --daemon start resourcemanager
  $HADOOP_HOME/bin/yarn --daemon start nodemanager
fi

tail -f /dev/null