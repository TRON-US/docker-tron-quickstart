# Tron Quickstart

FROM trontools/ubuntu-oracle-jre8
LABEL maintainers="Francesco Sullo <francesco@sullo.co>, elluck91 <lukasz@tron.network>"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8

RUN apt-get update && \
  apt-get install -y --no-install-recommends locales build-essential wget -y && \
  locale-gen "en_US.UTF-8" && \
  wget https://deb.nodesource.com/setup_10.x && \
  bash setup_10.x && \
  apt-get install -y nodejs --no-install-recommends redis-server && npm i -g pm2 && pm2 update && \
  apt-get clean all

# Prepare the work directory
RUN mkdir -p tron/conf
WORKDIR /tron

# Install proxy dependencies
RUN mkdir /tron/app
ADD app/package.json /tron/app/package.json
RUN cd app && npm install && \
  apt-get uninstall build-essential

# Configures full node
RUN mkdir FullNode
ADD conf/full.conf FullNode/fullnode.conf
ADD conf/FullNode.jar FullNode/FullNode.jar

RUN mkdir BlockParser
ADD conf/run.sh BlockParser/run.sh
ADD conf/BlockParser.jar BlockParser/BlockParser.jar

RUN mkdir eventron
ADD conf/process.json eventron/process.json
ADD conf/eventron eventron/eventron

# Separating install from src speeds up the rebuilding
# if the node app is changed, but has the ADD app/version

ADD app/index.js app/index.js
ADD app/version.js app/version.js
ADD app/src app/src
ADD scripts scripts
RUN chmod +x scripts/accounts-generation.sh

COPY test ./test
ADD tronWeb tronWeb
RUN chmod +x tronWeb

ADD quickstart.sh quickstart
RUN chmod +x quickstart
CMD ["./quickstart", "v2.0.1"]
