#!/usr/bin/env bash

set -e

PARAMS="-X POST -f -s -S -o - -u ${XP_USERNAME}:${XP_PASSWORD}" # Initializing arguments for curl command. 

if [ "$CLIENT_KEY" != "" ] && [ "$CLIENT_CERT" != "" ]; then    #Add the MTLS client key and cert in the argumetns list for the curl command.
    echo "Using mTLS"
    KEY=$(mktemp /tmp/key.XXXXXX)
    CERT=$(mktemp /tmp/crt.XXXXXX)
    echo -n "${CLIENT_KEY}" > ${KEY}
    echo -n "${CLIENT_CERT}" > ${CERT}
    PARAMS="${PARAMS} --key ${KEY} --cert ${CERT}"
fi

if [ -z "$APP_JAR" ]; then
	echo "No app name spsecified deploying every app under build/libs"
	apps=$(find ./build/libs  -type f -name "*.jar")
	for app in $apps; do
		TEMP_PARAMS="${PARAMS} -F file=@${app}"	#To avoid appending each file as argument in $PARAMS, use temporary variable for each file. 
		curl ${TEMP_PARAMS} ${XP_URL}/app/install
	done
else
	echo "App name and path specified"
	FILE="$(find . -wholename ./build/apps/${APP_JAR} | head -n 1)"
	if [ "$FILE" != "" ]; then
		PARAMS="${PARAMS} -F file=@${FILE}"
		curl ${PARAMS} ${XP_URL}/app/install
	else
		echo "The specified app does not exist"
	fi
fi
