FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV TEZ_HOME=/opt/tez
ENV HIVE_HOME=/opt/hive
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$TEZ_HOME/bin:$HIVE_HOME/bin

RUN apt-get update && apt-get install -y \
    openjdk-11-jdk wget curl ssh pdsh python3 \
    && rm -rf /var/lib/apt/lists/*

# Téléchargements
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.4.2/hadoop-3.4.2.tar.gz && \
    tar -xzvf hadoop-3.4.2.tar.gz -C /opt/ && mv /opt/hadoop-3.4.2 $HADOOP_HOME && rm hadoop-3.4.2.tar.gz

RUN wget https://archive.apache.org/dist/tez/0.10.2/apache-tez-0.10.2-bin.tar.gz && \
    tar -xzvf apache-tez-0.10.2-bin.tar.gz -C /opt/ && mv /opt/apache-tez-0.10.2-bin $TEZ_HOME && rm apache-tez-0.10.2-bin.tar.gz

RUN wget https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz && \
    tar -xzvf apache-hive-3.1.3-bin.tar.gz -C /opt/ && mv /opt/apache-hive-3.1.3-bin $HIVE_HOME && rm apache-hive-3.1.3-bin.tar.gz

# --- INJECTION DES CONFIGURATIONS (Fixe l'erreur de montage) ---
# Assurez-vous que ces fichiers existent dans votre dossier ./configs/
COPY configs/core-site.xml $HADOOP_HOME/etc/hadoop/
COPY configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/
COPY configs/log4j.properties $HADOOP_HOME/etc/hadoop/
COPY configs/hive-site.xml $HIVE_HOME/conf/
COPY configs/postgresql-jdbc.jar $HIVE_HOME/lib/
COPY configs/postgresql-jdbc.jar $HADOOP_HOME/share/hadoop/common/lib/

# Correctif SLF4J (conflit Hive/Hadoop 3)
RUN rm $HIVE_HOME/lib/log4j-slf4j-impl-*.jar

# Variable Classpath pour Tez
ENV HADOOP_CLASSPATH=$TEZ_HOME/*:$TEZ_HOME/lib/*:$HIVE_HOME/lib/*:$HADOOP_HOME/etc/hadoop

COPY entrypoint.sh /entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
