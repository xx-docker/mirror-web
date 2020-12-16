#!/bin/bash 
curdir=$(
  cd $(dirname $0)
  pwd
)/


cd $curdir ;

./sbin/tunasync manager --config ./conf/manager.conf > ./log/manger.log 2>&1
