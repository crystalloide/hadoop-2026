Projet 2026 
________________________________________________________________________________________________
## Exécution_cluster_Big_Data
Pour démarrer le cluster, exécutez les commandes suivantes depuis le répertoire du projet :

##### Sous Linux : clonage du projet : 
```sh
cd ~
sudo rm -Rf hadoop-2026

git clone https://github.com/crystalloide/hadoop-2026

cd hadoop-2026

```

### Démarrer le cluster avec les composants : 
##### HDFS MR HIVE PIG SQOOP ZEPPELIN HUE IMPALA OOZIE AIRFLOW ZOOKEEPER POSTGRESQL
Ce fichier démarre un cluster destiné à faire des expérimentations sur des machines limitées en ressource. 

##### Sous Linux
```sh
docker compose -f docker-compose.yaml up -d
```

```sh
docker ps -a
```

##### On initialise le schema pour Hive
```sh
docker exec -it hive-metastore /opt/hive/bin/schematool -dbType postgres -initSchema
```

##### Après quelques minutes : on vérifie le niveau de consommation des ressources 
```sh
docker stats
```
