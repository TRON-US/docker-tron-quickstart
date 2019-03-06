# Tron Quickstart

FROM ubuntu:18.04
LABEL maintainer="Francesco Sullo <francesco@sullo.co>"

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jre
ENV PATH="/usr/lib/jre/bin:${PATH}"

RUN apt-get update && apt-get install build-essential -y

RUN apt-get install -y wget && \
  wget https://deb.nodesource.com/setup_8.x && \
  bash setup_8.x && \
  apt-get install -y nodejs

RUN apt install -y --no-install-recommends redis-server

# Prepare the work directory
RUN mkdir -p tron/conf
WORKDIR /tron

# Add jre
ADD jre /usr/lib/jre
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

RUN mkdir eventron && cd eventron && npm install sleep
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
CMD ["./quickstart", "v1.2.8"]
