#!/bin/sh
# 5分に1回harvester runを実行する
while true 
do
    ckan --config=/srv/app/ckan.ini harvester run
    sleep 300
done
