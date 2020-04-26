#!/bin/bash

# Helper function to gracefully shut down our child processes when we exit.
clean_exit() {
    for PID in $NODERED_PID; do
        if kill -0 $PID 2>/dev/null; then
            kill -SIGTERM "$PID"
            wait "$PID"
        fi
    done
}

# Make bash listen to the SIGTERM and SIGINT kill signals, and make them trigger
# a normal "exit" command in this script. Then we tell bash to execute the
# "clean_exit" function, seen above, in the case an "exit" command is triggered.
# This is done to give the child processes a chance to exit gracefully.
trap "exit" TERM INT
trap "clean_exit" EXIT

# When starting, execute npm install with userDir package.json
# This allow to ignore 'node_modules' folder when saving project

pwd
if [ -f "/data/package.json" ]
then
  mv package.json package.docker.json --verbose
  cp /data/package.json . --verbose
  npm install --no-package-lock
  cp package.json package.data.json --verbose
  cp package.docker.json package.json
fi

npm start -- --userDir /data
NODERED_PID=$!

# NodeRED process is now our children. As a parent
# we will wait for its PIDs, and if it exits we will follow
# suit and use the same status code as the program.
wait -n $NODERED_PID
exit $?
