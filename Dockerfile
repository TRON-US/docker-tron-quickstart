
# FROM ubuntu:18.04

FROM partlab/ubuntu

LABEL name="Tron Quickstart @0.1.0"
LABEL author="Francesco Sullo <francesco@sullo.co>"
LABEL licence="MIT"

# Install JDK8
# thanks to mlaccetti/docker-oracle-java8-ubuntu-16.04

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-oracle
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8
ENV INITRD          No

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


# Install Node

RUN apt-get install -y wget && \
  wget https://deb.nodesource.com/setup_8.x && \
  bash setup_8.x && \
  apt-get install -y nodejs


# Install MongoDB
# thanks to partlab/ubuntu-mongodb

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' \
      | tee /etc/apt/sources.list.d/10gen.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends mongodb-org && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/data/db"]

# Prepare the work directory

RUN mkdir tron
WORKDIR /tron

ADD conf /tron/conf

RUN apt-get update && \
  apt-get install maven -y && \
  apt-get clean

# Clone and build java-tron


RUN git clone https://github.com/tronprotocol/java-tron.git && \
  cd java-tron && \
  git fetch && \
  git checkout shasta-dev && \
  cp ../conf/mongodb.properties src/main/resources/. && \
  ./gradlew build -x test && \
  cd ..


# Clone and build trongrid

RUN git clone https://github.com/tronprotocol/tron-grid.git && \
  cd tron-grid && \
  cp ../conf/application.properties src/main/resources/. && \
  mvn package -Dmaven.test.skip=true && \
  mv target/trongrid-0.0.1-SNAPSHOT.jar target/EventServer.jar && \
  cd ..

# Configures full and solidity node

RUN mkdir FullNode && \
  cp java-tron/build/libs/FullNode.jar FullNode/. && \
  mv conf/fullnode.conf FullNode/config.conf

RUN mkdir SolidityNode && \
  cp java-tron/build/libs/SolidityNode.jar SolidityNode/. && \
  mv conf/soliditynode.conf SolidityNode/config.conf


# Install proxy dependencies

RUN apt-get install build-essential -y

ADD app /tron/app
RUN cd app && npm install

RUN apt-get remove maven git -y && \
  apt-get clean all && \
  apt-get autoremove -y

ADD start.sh /tron/start.sh
RUN chmod +x start.sh

CMD ["./start.sh"]
#
#CMD ["bash"]
