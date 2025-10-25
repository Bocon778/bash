#!/bin/bash

export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if [ -n "$NODE_VERSION" ]; then
    nvm use "$NODE_VERSION"
else
    nvm use default
fi

cd /home/container

if [ -z "${STARTUP}" ]; then
    STARTUP="bash"
fi

MODIFIED_STARTUP=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')

eval "${MODIFIED_STARTUP}"