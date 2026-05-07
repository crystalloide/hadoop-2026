#!/bin/bash

# Configuration des répertoires pour Hadoop 3.4.2
HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
TEZ_TARBALL="/opt/tez/apache-tez-0.10.2-bin.tar.gz"

# 1. Formatage du Namenode (uniquement s'il n'est pas déjà formaté)
if [ ! -d "/hadoop/dfs/name/current" ]; then
  echo "Initialisation du système de fichiers HDFS..."
  $HADOOP_HOME/bin/hdfs namenode -format -force
fi

# 2. Démarrage des services HDFS
$HADOOP_HOME/bin/hdfs --daemon start namenode
$HADOOP_HOME/bin/hdfs --daemon start datanode

# 3. Attente que HDFS sorte du mode "Safe Mode"
echo "Attente de la sortie du mode sans échec..."
$HADOOP_HOME/bin/hdfs dfsadmin -safemode wait

# 4. Déploiement automatique de Tez sur HDFS
echo "Vérification de la présence de Tez sur HDFS..."
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /apps/tez
if ! $HADOOP_HOME/bin/hdfs dfs -test -e /apps/tez/tez-0.10.2.tar.gz; then
  echo "Téléchargement de l'archive Tez vers HDFS..."
  $HADOOP_HOME/bin/hdfs dfs -put $TEZ_TARBALL /apps/tez/tez-0.10.2.tar.gz
fi

# 5. Démarrage de YARN (Resource Manager & Node Manager)
$HADOOP_HOME/bin/yarn --daemon start resourcemanager
$HADOOP_HOME/bin/yarn --daemon start nodemanager

echo "Cluster Hadoop 3.4.2 avec Tez prêt !"

# Maintien du conteneur en vie en affichant les logs
tail -f $HADOOP_HOME/logs/*