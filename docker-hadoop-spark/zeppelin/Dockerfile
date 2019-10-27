FROM molab/spark-yarn

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
ADD startup.sh $ZEPPELIN_HOME/startup.sh
RUN chmod +x $ZEPPELIN_HOME/startup.sh

#ENTRYPOINT $ZEPPELIN_HOME/startup.sh
ENTRYPOINT /bin/bash
