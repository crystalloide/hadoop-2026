FROM ubuntu:24.04

# Éviter les interactions lors de l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Installation des dépendances
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk wget curl ssh pdsh python3 \
    && rm -rf /var/lib/apt/lists/*

# Variables d'environnement globales
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV TEZ_HOME=/opt/tez
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$TEZ_HOME/bin

# 1. Récupération de Hadoop 3.4.2
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.4.2/hadoop-3.4.2.tar.gz && \
    tar -xzvf hadoop-3.4.2.tar.gz -C /opt/ && \
    mv /opt/hadoop-3.4.2 $HADOOP_HOME && \
    rm hadoop-3.4.2.tar.gz

# 2. Récupération de Tez 0.10.2 (version stable pour Hadoop 3)
RUN wget https://archive.apache.org/dist/tez/0.10.2/apache-tez-0.10.2-bin.tar.gz && \
    tar -xzvf apache-tez-0.10.2-bin.tar.gz -C /opt/ && \
    mv /opt/apache-tez-0.10.2-bin $TEZ_HOME && \
    rm apache-tez-0.10.2-bin.tar.gz

# Configuration du Classpath pour inclure Tez
ENV HADOOP_CLASSPATH=$TEZ_HOME/*:$TEZ_HOME/lib/*:$HADOOP_HOME/etc/hadoop

WORKDIR $HADOOP_HOME
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]