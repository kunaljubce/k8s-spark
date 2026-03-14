FROM openjdk:17.0.1-jdk-slim

ENV SPARK_VERSION=4.1.1
ENV HADOOP_VERSION=3

RUN apt-get update && apt-get install -y curl

RUN curl -O https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-connect.tgz && \
		tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-connect.tgz && \
		mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-connect /spark && \
		rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-connect.tgz

ENV SPARK_HOME /spark
ENV PATH $PATH:$SPARK_HOME/bin

WORKDIR /spark/work-dir

ENTRYPOINT ["/spark/bin/spark-submit"]