Docker image: local *spark* instalace s notebookem *zeppelin* a běžícím *spark-history-server*.
Data pro notebooky namountovaná na lokální složku notebook a data sloužící jako úložiště namountovaná pod lokální složkou work.

## Komponenty
- Ubuntu 18.10
- Java 8
- Spark version="2.4.3" (Hadoop 2.7)
- Zeppelin version="0.8.1"


## Build image

```
docker build -t spark-zeppelin-docker .
```

## Start the container
```
docker run -it -v $(pwd)/work:/work -v $(pwd)/notenook:/usr/zeppelin/zeppelin-0.8.1-bin-all/notebook/ -p 18080:18080 -p 8088:8080 -d spark-zeppelin-docker
```

## Otevření Zeppelin and Spark History Server

- Zeppelin: http://localhost:8088/#/
- Spark History Server: http://localhost:18080/?showIncomplete=true

POZN: vyčkat 10 second než nastartuje Zeppelin daemon.
