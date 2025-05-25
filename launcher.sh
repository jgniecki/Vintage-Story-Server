#!/bin/bash

#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
    ./server.sh stop
}

#Trap SIGTERM
trap 'true' SIGTERM

# Starts the server
./server.sh start
# Sleep to prevent a container stop
sleep infinity &

#Wait
wait

#Cleanup
cleanup