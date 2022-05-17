#!/bin/bash

mkdir -p /root/.ssh

if [ -d /root/win-ssh ]; then
    cp -r /root/win-ssh/* /root/.ssh;
    for file in /root/.ssh/*; do chmod 600 "$file"; done
fi

tail /proc/1/fd/1
