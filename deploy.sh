#!/usr/bin/env bash

set -e

FILE="$(find . -wholename ${APP_JAR} | head -n 1)"

if [ -z "$FILE" ]; then
    echo "No app jar found with pattern: ${APP_JAR}"
    exit 1
else
    echo "Found app jar: ${FILE}"
fi

PARAMS="-X POST -f -s -S -o - -u ${XP_USERNAME}:${XP_PASSWORD} -F file=@${FILE}"

if [ "$CLIENT_KEY" != "" ] && [ "$CLIENT_CERT" != "" ]; then    #Add the MTLS client key and cert in the parameters list for the curl command.
    echo "Using mTLS"
    KEY=$(mktemp /tmp/key.XXXXXX)
    CERT=$(mktemp /tmp/crt.XXXXXX)
    echo -n "${CLIENT_KEY}" > ${KEY}
    echo -n "${CLIENT_CERT}" > ${CERT}
    PARAMS="${PARAMS} --key ${KEY} --cert ${CERT}"
fi

curl ${PARAMS} ${XP_URL}/app/install
