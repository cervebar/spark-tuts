FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y software-properties-common

####################
# JAVA
####################
# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# set default java environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN add-apt-repository ppa:openjdk-r/ppa -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*


####################
# HADOOP
####################

ENV HADOOP_VERSION	2.6.0
ENV HADOOP_HOME		/usr/local/hadoop
ENV HADOOP_OPTS		-Djava.library.path=/usr/local/hadoop/lib/native
ENV PATH		$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget libzip2 libsnappy1 libssl-dev && \
    wget http://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    apt-get remove -y wget && \
    rm -rf /var/lib/apt/lists/* && \
    tar -zxf /hadoop-$HADOOP_VERSION.tar.gz && \
    rm /hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION /usr/local/hadoop && \
    mkdir -p /usr/local/hadoop/logs


# Overwrite default HADOOP configuration files with our config files
COPY conf  $HADOOP_HOME/etc/hadoop/

# Formatting HDFS
RUN mkdir /data && \
    hdfs namenode -format
VOLUME /data
RUN mkdir  -p /data/dfs/data /data/dfs/name /data/dfs/namesecondary


# Helper script for starting YARN
ADD start-yarn.sh /usr/local/bin/start-yarn.sh



####################
# PORTS
####################
#
# http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.0/bk_HDP_Reference_Guide/content/reference_chap2.html
# http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cdh_ig_ports_cdh5.html
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/core-default.xml
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

# HDFS: NameNode (NN):
#	 8020 = fs.defaultFS			(IPC / File system metadata operations)
#						(9000 is also frequently used alternatively)
#	 8022 = dfs.namenode.servicerpc-address	(optional port used by HDFS daemons to avoid sharing RPC port)
#       50070 = dfs.namenode.http-address	(HTTP  / NN Web UI)
#	50470 = dfs.namenode.https-address	(HTTPS / Secure UI)
# HDFS: DataNode (DN):
#	50010 = dfs.datanode.address		(Data transfer)
#	50020 = dfs.datanode.ipc.address	(IPC / metadata operations)
#	50075 = dfs.datanode.http.address	(HTTP  / DN Web UI)
#	50475 = dfs.datanode.https.address	(HTTPS / Secure UI)
# HDFS: Secondary NameNode (SNN)
#	50090 = dfs.secondary.http.address	(HTTP / Checkpoint for NameNode metadata)
EXPOSE 9000 50070 50010 50020 50075 50090



CMD ["hdfs"]


## SPARK ##########################################
RUN apt-get update && apt-get install -y curl && \
    curl -s http://apache.mirror.anlx.net/spark/spark-2.3.4/spark-2.3.4-bin-hadoop2.6.tgz | tar -xz -C /usr/local/ && \
    apt-get remove -y curl
RUN cd /usr/local && ln -s spark-2.3.4-bin-hadoop2.6 spark
ENV SPARK_HOME /usr/local/spark

ENV YARN_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_HOME/bin

RUN echo spark.yarn.jars hdfs:///spark-lib/*.jar > $SPARK_HOME/conf/spark-defaults.conf

ADD bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh
RUN ./bootstrap.sh

## ZEPPELIN
# Updates & Install Prerequisites
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget curl npm git
WORKDIR /tmp/

ENV ZEPPELIN_HOME /usr/local/zeppelin
RUN mkdir -p $ZEPPELIN_HOME

WORKDIR $ZEPPELIN_HOME
RUN wget http://mirror.hosting90.cz/apache/zeppelin/zeppelin-0.8.2/zeppelin-0.8.2-bin-all.tgz &&  tar -zvxf zeppelin-0.8.2-bin-all.tgz && rm zeppelin-0.8.2-bin-all.tgz && mv zeppelin-0.8.2-bin-all/* .

EXPOSE 8080 8081

ADD interpreter-setting.json $ZEPPELIN_HOME/interpreter/spark/interpreter-setting.json

ADD zeppelin-env.sh $ZEPPELIN_HOME/conf/zeppelin-env.sh
ADD zeppelin-site.xml $ZEPPELIN_HOME/conf/zeppelin-site.xml

# GOTO IT
#ENTRYPOINT /bin/bash
