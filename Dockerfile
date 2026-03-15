FROM openjdk:17.0.1-jdk-slim

ENV SPARK_VERSION=4.1.1
ENV HADOOP_VERSION=3

RUN apt-get update && apt-get install -y curl tini

RUN curl -O https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
		tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
		mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark && \
		rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

RUN cp /spark/kubernetes/dockerfiles/spark/entrypoint.sh /opt/entrypoint.sh && \
		chmod a+x /opt/entrypoint.sh

ENV SPARK_HOME /spark
ENV PATH $PATH:$SPARK_HOME/bin

WORKDIR /spark/work-dir

ENTRYPOINT ["/opt/entrypoint.sh"]