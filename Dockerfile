FROM python:3.11-bullseye as spark-base

ARG SPARK_VERSION=3.5.0

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  sudo \
  curl \
  vim \
  unzip \
  rsync \
  openjdk-11-jdk \
  build-essential \
  software-properties-common \
  ssh && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*



## Download spark and hadoop dependencies and install

# Optional env variables
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}

RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME}
WORKDIR ${SPARK_HOME}

COPY ./install-packages/spark-${SPARK_VERSION}-bin-hadoop3.tgz .

RUN tar xvzf spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory /opt/spark --strip-components 1 \
  && rm -rf spark-${SPARK_VERSION}-bin-hadoop3.tgz


FROM spark-base as pyspark

# Install python deps
COPY requirements.txt .
RUN pip3 install -r requirements.txt

ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"
ENV SPARK_HOME="/opt/spark"
ENV SPARK_MASTER="spark://spark-master:7077"
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

COPY conf/spark-defaults.conf "$SPARK_HOME/conf"

RUN chmod u+x /opt/spark/sbin/* && \
  chmod u+x /opt/spark/bin/*

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

COPY entrypoint.sh .

RUN chmod u+x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

WORKDIR "${SPARK_HOME}/jars"
COPY ./install-packages/hadoop-common-3.3.4.jar .
COPY ./install-packages/hadoop-aws-3.3.4.jar .
COPY ./install-packages/aws-java-sdk-bundle-1.12.262.jar .

WORKDIR ${SPARK_HOME}