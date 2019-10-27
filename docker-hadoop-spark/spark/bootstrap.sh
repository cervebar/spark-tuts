#!/bin/bash

# add jars to HDFS, yarn will reuse it -------------
$HADOOP_HOME/bin/hdfs dfs -test -d /spark-lib
if [ $? != 0 ]
then
  echo "adding spark jar to /spark-lib"
  $HADOOP_HOME/bin/hdfs dfs -put $SPARK_HOME/jars /spark-lib
else
  echo "Spark already on HDFS"
fi

# add spark to path ------------------------------
echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export SPARK_HOME=/usr/local/spark
export PATH=$PATH:$SPARK_HOME/bin
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH" >> ~/.bashrc
