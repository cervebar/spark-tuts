



# LCIENCE, credits
based on tutorial: https://github.com/informatics-lab/docker-hadoop-spark


# Docker Spark Hadoop Zeppelin
* OS - Ubuntu 18.10
* Java 8 (openjdk)
* Hadoop 2.7.0
* Spark 2.4.4
* Zeppelin 0.8.2

TODO - obrazek co je cilem


## Hadoop image

```
docker build -t lab/hadoop hadoop
```

## Run Hadoop

```
docker-compose -f hadoop/docker-compose.yml up -d
```

TODO obrazek jak to vypada up and running

### Web UI:
* Resource manager: http://localhost:8088/cluster/apps
* HDFS: http://localhost:50070/dfshealth.html#tab-overview

## Spark image

```
docker build -t lab/spark-yarn spark
```

## Run a spark shell

```
docker run --rm -ti --link=hadoop_yarn_1:yarn --link=hadoop_namenode_1:namenode lab/spark-yarn
```

### ověření:

```
./bootstrap.sh
hdfs dfs -ls /spark-lib
```

```
cd /usr/local/spark
spark-submit --deploy-mode cluster --master yarn --class org.apache.spark.examples.SparkPi examples/jars/spark-examples_2.11-2.4.4.jar 10
```

```
./bin/spark-shell --master yarn --deploy-mode client
```


## Build notebook

```
docker build -t lab/spark-notebook notebook
```

## Run a notebook

```
docker run --rm -ti --link=hadoop_yarn_1:yarn --link=hadoop_namenode_1:namenode lab/spark-notebook
```

In the notebook run

```
from pyspark import SparkContext
sc = SparkContext(master="yarn-client")
```

## Build Zeppelin

```
docker build -t lab/zeppelin zeppelin
```

## Run zeppelin

```
docker run --rm -ti -p 8080:8080 -p 8081:8081 --link=hadoop_yarn_1:yarn --link=hadoop_namenode_1:namenode lab/zeppelin
```
