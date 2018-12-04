# Tron Quickstart

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

RUN mkdir -p tron/conf
WORKDIR /tron


# Clone and build java-tron

ADD conf/logback.xml /tron/conf/logback.xml
ADD conf/mongodb.properties /tron/conf/mongodb.properties
RUN apt-get install git -y && \
  git clone https://github.com/tronprotocol/java-tron.git && \
  cd java-tron && \
  git fetch && \
  git checkout shasta-dev && \
  cp ../conf/mongodb.properties src/main/resources/. && \
  cp ../conf/logback.xml src/main/resources/. && \
  ./gradlew build -x test && \
  cd ..


# Clone and build trongrid

ADD conf/application.properties /tron/conf/application.properties
RUN git clone https://github.com/tronprotocol/tron-grid.git && \
  cd tron-grid && \
  cp ../conf/application.properties src/main/resources/. && \
  apt-get install -y maven && \
  mvn package && \
  mv target/trongrid-1.0.1-SNAPSHOT.jar target/EventServer.jar && \
  cd ..


# Configures full and solidity node

ADD conf/full.conf /tron/conf/fullnode.conf
RUN mkdir FullNode && \
  cp java-tron/build/libs/FullNode.jar FullNode/. && \
  mv conf/fullnode.conf FullNode/config.conf

ADD conf/solidity.conf /tron/conf/soliditynode.conf
RUN mkdir SolidityNode && \
  cp java-tron/build/libs/SolidityNode.jar SolidityNode/. && \
  mv conf/soliditynode.conf SolidityNode/config.conf


# Install proxy dependencies

RUN apt-get update && apt-get install build-essential -y

RUN mkdir /tron/app
ADD app/package.json /tron/app/package.json
ADD app/package-lock.json /tron/app/package-lock.json

RUN cd app && npm install

RUN apt-get remove maven git -y && \
  apt-get clean all && \
  apt-get autoremove -y

# Separating install from src speeds up the rebuilding
# if the node app is changed, but has the same dependences

ADD app/index.js /tron/app/index.js
ADD app/version.js /tron/app/version.js
ADD app/src /tron/app/src
ADD scripts /tron/scripts

ADD tronWeb /tron/tronWeb
RUN chmod +x tronWeb

ADD conf/set-mongo /tron/conf/set-mongo
ADD start.sh /tron/start.sh
RUN chmod +x start.sh

CMD ["./start.sh"]
