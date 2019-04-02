#!/usr/bin/env bash

if [[ $preapprove != '' ]]; then

   while IFS=',' read -ra ADDR; do
        for i in "${ADDR[@]}"; do
            echo "  ${i/:/ = }" >> /tron/FullNode/fullnode.conf
        done
   done <<< "$preapprove"

else

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

  if [[ $allowMultiSign == '1' ]];then
    echo "Pre-approving allowMultiSign"
    echo "  allowMultiSign = 1" >> /tron/FullNode/fullnode.conf
  fi

fi

echo "}" >> /tron/FullNode/fullnode.conf
