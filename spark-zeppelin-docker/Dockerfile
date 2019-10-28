FROM ubuntu:18.10

ARG ZEPPELIN_VERSION="0.8.1"
ARG SPARK_VERSION="2.3.4"
ARG HADOOP_VERSION="2.7"

LABEL maintainer "mirkoprescha"
LABEL zeppelin.version=${ZEPPELIN_VERSION}
LABEL spark.version=${SPARK_VERSION}
LABEL hadoop.version=${HADOOP_VERSION}

# Install Java and some tools
RUN apt-get -y update &&\
    apt-get -y install curl less &&\
    apt-get install -y openjdk-8-jdk &&\
    apt-get -y install vim


##########################################
# SPARK
##########################################
ARG SPARK_ARCHIVE=http://apache.mirror.anlx.net/spark/spark-2.3.4/spark-2.3.4-bin-hadoop2.7.tgz
RUN echo $SPARK_ARCHIVE
RUN mkdir /usr/local/spark &&\
    mkdir /tmp/spark-events    # log-events for spark history server
ENV SPARK_HOME /usr/local/spark

ENV PATH $PATH:${SPARK_HOME}/bin
RUN curl -s ${SPARK_ARCHIVE} | tar -xz -C  /usr/local/spark --strip-components=1

COPY spark-defaults.conf ${SPARK_HOME}/conf/


##########################################
# Zeppelin
##########################################
RUN mkdir /usr/zeppelin &&\
    curl -s http://mirror.softaculous.com/apache/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-all.tgz | tar -xz -C /usr/zeppelin
RUN echo '{ "allow_root": true }' > /root/.bowerrc

ENV ZEPPELIN_PORT 8080
EXPOSE $ZEPPELIN_PORT
EXPOSE 4040
EXPOSE 4041

ENV ZEPPELIN_HOME /usr/zeppelin/zeppelin-${ZEPPELIN_VERSION}-bin-all
ENV ZEPPELIN_CONF_DIR $ZEPPELIN_HOME/conf
ENV ZEPPELIN_NOTEBOOK_DIR $ZEPPELIN_HOME/notebook

RUN mkdir -p $ZEPPELIN_HOME \
  && mkdir -p $ZEPPELIN_HOME/logs \
  && mkdir -p $ZEPPELIN_HOME/run


# my WorkDir
RUN mkdir /work
WORKDIR /work


ENTRYPOINT  /usr/local/spark/sbin/start-history-server.sh;  $ZEPPELIN_HOME/bin/zeppelin-daemon.sh start; /bin/bash

