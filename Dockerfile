# Tron Quickstart @0.0.4

FROM ubuntu:18.04
LABEL maintainer="Francesco Sullo <francesco@sullo.co>"


# Install JDK8
# thanks to mlaccetti/docker-oracle-java8-ubuntu-16.04

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-oracle
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8

RUN apt-get update && \
  apt-get install -y --no-install-recommends locales && \
  locale-gen "en_US.UTF-8" && \
  apt-get dist-upgrade -y && \
  apt-get install gnupg apt-utils git -y && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer oracle-java8-set-default && \
  apt-get clean all


# Install MongoDB

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
  echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list && \
  apt-get update && \
  apt-get install -y libcurl4 && \
  apt-get install -y mongodb-org && \
  mkdir -p /data/db


# Install Node

RUN apt-get install -y wget && \
  wget https://deb.nodesource.com/setup_8.x && \
  bash setup_8.x && \
  apt-get install -y nodejs


# Prepare the work directory

RUN mkdir tron
WORKDIR /tron

ADD conf /tron/conf

# Clone and build java-tron

RUN apt-get install git -y && \
  git clone https://github.com/tronprotocol/java-tron.git && \
  cd java-tron && \
  git fetch && \
  git checkout test_ev2 && \
  cp ../conf/mongodb.properties src/main/resources/. && \
  ./gradlew build -x test && \
  cd ..


# Clone and build trongrid

RUN git clone https://github.com/tronprotocol/tron-grid.git && \
  cd tron-grid && \
  cp ../conf/application.properties src/main/resources/. && \
  apt-get install -y maven && \
  mvn package && \
  mv target/trongrid-0.0.1-SNAPSHOT.jar target/EventServer.jar && \
  cd ..


# Configures full and solidity node

ADD app /tron/app
ADD start.sh /tron/start.sh

RUN mkdir FullNode && \
  cp java-tron/build/libs/FullNode.jar FullNode/. && \
  mv conf/fullnode.conf FullNode/config.conf

RUN mkdir SolidityNode && \
  cp java-tron/build/libs/SolidityNode.jar SolidityNode/. && \
  mv conf/soliditynode.conf SolidityNode/config.conf


# Install proxy dependencies

RUN chmod +x start.sh && \
  cd app && \
  npm install


CMD ["./start.sh"]
