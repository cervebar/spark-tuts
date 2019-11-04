FROM lab/hadoop

RUN apt-get update && apt-get install -y curl && \
    curl -s http://apache.mirror.anlx.net/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz | tar -xz -C /usr/local/ && \
    apt-get remove -y curl
RUN cd /usr/local && ln -s spark-2.4.4-bin-hadoop2.7 spark
ENV SPARK_HOME /usr/local/spark

ENV YARN_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_HOME/bin

RUN echo spark.yarn.jars hdfs:///spark-lib/*.jar > $SPARK_HOME/conf/spark-defaults.conf

RUN mkdir /tmp/spark-events    # log-events for spark history server

ENV PATH $PATH:${SPARK_HOME}/bin

ADD bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh

EXPOSE 4041

ADD bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh

ENTRYPOINT /bootstrap.sh;usr/local/spark/sbin/start-history-server.sh;/bin/bash
