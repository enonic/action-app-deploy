#!/bin/bash

docker build -t my-action ./action

cred_file=$(< ./sa.json)

docker run --rm \
 -e ENONIC_CLI_REMOTE_URL="http://host.docker.internal:4848" \
 -e CRED_FILE="$cred_file" \
 -v $(pwd)/app:/github/workspace \
 my-action

# -e CRED_FILE="test" \
#-e APP_JAR="./build/libs/*.jar" \
