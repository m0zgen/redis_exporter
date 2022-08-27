#!/bin/bash
# Post_u
# Created by Y.G., https://sys-adm.in

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

_USER=redis-exporter

systemctl --system daemon-reload; 

getent passwd $_USER > /dev/null 2&>1

if [ $? -eq 0 ]; then
    userdel -f ${_USER}
fi

