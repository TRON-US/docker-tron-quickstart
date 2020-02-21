#!/usr/bin/env bash

sleep 10
nohup java -jar BlockParser.jar --node-list 127.0.0.1 --start 1 --end -1 --event-server http://127.0.0.1:8060 --secret-key TNSpckEZhGfZ4ryidHG2fYWMARLpZ6U139 --as-list --event > /dev/null 2>&1 &
