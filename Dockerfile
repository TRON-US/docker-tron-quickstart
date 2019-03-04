# Tron Quickstart

FROM ubuntu:18.04
LABEL maintainer="Francesco Sullo <francesco@sullo.co>"


ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jre

RUN apt-get install -y wget && \
  wget https://deb.nodesource.com/setup_8.x && \
  bash setup_8.x && \
  apt-get install -y nodejs

RUN apt install redis-server
RUN systemctl restart redis.service

# Prepare the work directory

RUN mkdir -p tron/conf
WORKDIR /tron


#RUN echo '3.5.0.1'

# Install proxy dependencies

RUN apt-get update && apt-get install build-essential -y

RUN mkdir /tron/app
ADD app/package.json /tron/app/package.json
ADD app/package-lock.json /tron/app/package-lock.json

RUN cd app && npm install

# Configures full and solidity node

RUN mkdir FullNode
ADD conf/full.conf FullNode/fullnode.conf
ADD conf/FullNode.jar FullNode/FullNode.jar

RUN mkdir BlockParser
ADD conf/run.sh BlockParser/run.sh
ADD conf/BlockParser.jar BlockParser/BlockParser.jar

RUN mkdir eventron
ADD conf/test-env eventron/env
ADD conf/eventron.js eventron/index.js

# Separating install from src speeds up the rebuilding
# if the node app is changed, but has the ADD app/version

ADD app/index.js app/index.js
ADD app/version.js app/version.js
ADD app/src app/src
ADD scripts scripts
RUN chmod +x scripts/accounts-generation.sh

ADD tronWeb tronWeb
RUN chmod +x tronWeb

ADD quickstart.sh quickstart
RUN chmod +x quickstart

CMD ["./quickstart", "v1.2.8"]
