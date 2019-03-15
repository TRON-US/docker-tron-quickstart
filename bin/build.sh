#!/usr/bin/env bash

BPSIZE=$(wc -c conf/BlockParser.jar | awk '{print $1}')
BPSIZE=$(($BPSIZE))

if [[ $BPSIZE < 1000000 ]]; then

  echo "
Whoops... Your repo is not ready.
Most likely you didn't pull a couple of large files.
To do it, install git-lfs:

    git lfs install

and pull the large files:

   git lfs pull
"

fi

docker build -t tronquickstart .