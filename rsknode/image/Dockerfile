FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

# BASICS
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget systemd supervisor nodejs npm openssl ca-certificates gnupg software-properties-common make build-essential

# JAVA
RUN (wget -O- https://apt.corretto.aws/corretto.key | apt-key add -) \
    && add-apt-repository 'deb https://apt.corretto.aws stable main' \
    && apt-get update
    && apt-get install -y java-11-amazon-corretto-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# RSK
WORKDIR /root
RUN wget https://github.com/rsksmart/rskj/releases/download/IRIS-3.3.0/rskj-core-3.3.0-IRIS-all.jar -O rsk.jar
COPY logback.xml /etc/rsk/logback.xml

EXPOSE 4444
EXPOSE 4445
EXPOSE 50505

ENTRYPOINT java -Xmx4G \
    -Drsk.conf.file=/etc/rsk/node.conf \
    -cp rsk.jar co.rsk.Start

