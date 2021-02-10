#!/bin/bash

mkdir -p /var/run/ranger
service ranger-admin start | tee -a /tmp/ranger_start.txt
service ranger-usersync start | tee -a /tmp/usersync_start.txt
