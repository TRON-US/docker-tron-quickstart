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
  apt-get install -y --no-install-recommends locales build-essential wget -y && \
  locale-gen "en_US.UTF-8" && \
  apt-get dist-upgrade -y && \
  apt-get install gnupg apt-utils git -y && \
  echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  apt-get install -y --no-install-recommends oracle-java8-installer oracle-java8-set-default && \
  apt-get clean all

RUN wget https://deb.nodesource.com/setup_8.x && \
  bash setup_8.x && \
  apt-get install -y nodejs

RUN apt install -y --no-install-recommends redis-server

# Prepare the work directory
RUN mkdir -p tron/conf
WORKDIR /tron

# Install proxy dependencies
RUN mkdir /tron/app
ADD app/package.json /tron/app/package.json
ADD app/package-lock.json /tron/app/package-lock.json

# Configures full node
RUN mkdir FullNode
ADD conf/full.conf FullNode/fullnode.conf
ADD conf/FullNode.jar FullNode/FullNode.jar

RUN mkdir BlockParser
ADD conf/run.sh BlockParser/run.sh
ADD conf/BlockParser.jar BlockParser/BlockParser.jar

RUN mkdir eventron
ADD conf/run_eventron.sh eventron/run_eventron.sh
ADD conf/eventron eventron/eventron

# Separating install from src speeds up the rebuilding
# if the node app is changed, but has the ADD app/version

ADD app/index.js app/index.js
ADD app/version.js app/version.js
ADD app/src app/src
ADD scripts scripts
RUN cd app && npm install
RUN chmod +x scripts/accounts-generation.sh

COPY test ./test
ADD tronWeb tronWeb
RUN chmod +x tronWeb

COPY kill_all.sh kill_all
RUN chmod +x kill_all
ADD quickstart.sh quickstart
RUN chmod +x quickstart
CMD ["./quickstart", "v2.0.0"]
