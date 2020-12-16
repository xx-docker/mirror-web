#!/bin/bash
curdir=$(
  cd $(dirname $0)
  pwd
)/


cd $curdir ;

./sbin/tunasync worker --config ./conf/workers-mini.conf > ./log/workers.log 2>&1
