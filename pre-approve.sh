#!/usr/bin/env bash

if [[ $getTotalEnergyTargetLimit == '1' ]];then
  echo "Pre-approving getTotalEnergyTargetLimit"
  echo "  getTotalEnergyTargetLimit = 1" >> /tron/FullNode/fullnode.conf
fi

if [[ $getUpdateAccountPermissionFee == '1' ]];then
  echo "Pre-approving getUpdateAccountPermissionFee"
  echo "  getUpdateAccountPermissionFee = 1" >> /tron/FullNode/fullnode.conf
fi

if [[ $getMultiSignFee == '1' ]];then
  echo "Pre-approving getMultiSignFee"
  echo "  getMultiSignFee = 1" >> /tron/FullNode/fullnode.conf
fi

echo "}" >> /tron/FullNode/fullnode.conf
