#!/usr/bin/env bash

wget -qO- http://127.0.0.1:9090/wallet/getnowblock
wget -qO- http://127.0.0.1:9090/walletsolidity/getnowblock
wget -qO- http://127.0.0.1:9090/healthcheck
