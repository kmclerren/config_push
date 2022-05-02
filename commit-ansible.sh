#!/bin/bash

files=$(git diff --name-only $CI_COMMIT_BEFORE_SHA $CI_COMMIT_SHA)

configs=$(for x in $files; do echo $x | grep '.conf'; done;)
devices=$(for x in $configs; do echo $x | sed 's/.conf//g'; done;)

limit=$(echo "$devices" | xargs | sed -e 's/ /,/g')

echo limited: $limit

if [ "$limit" = "" ]
then
   echo "No devices specified"
   exit 1
else
    ansible-playbook -i ./config_push/inventory ./config_push/commit.pb.yaml --limit $limit
fi
