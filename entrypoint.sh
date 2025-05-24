#!/bin/bash

sleep 5

cd /home/container || {
    echo "ERROR: Failed to change to /home/container directory"
    exit 1
}

if [ -z "${STARTUP}" ]; then
    echo "No startup command provided, defaulting to bash"
    STARTUP="bash"
fi

MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo "Executing command: ${MODIFIED_STARTUP}"
echo ":/home/container$ ${MODIFIED_STARTUP}"

eval ${MODIFIED_STARTUP}