#!/usr/bin/env bash
set -e
FILE="$(find . -wholename ${APP_JAR} | head -n 1)"

if [ -z "$FILE" ]; then
    echo "No app jar found with pattern: ${APP_JAR}"
    exit 1
else
    echo "Found app jar: ${FILE}"
fi

PARAMS="-X POST -f -s -S -o - -u ${XP_USER}:${XP_PASSWORD} -F file=@${FILE}"

if [ "$CLIENT_KEY" != "" ] && [ "$CLIENT_CERT" != "" ]; then
    echo "Using mTLS"
    KEY=$(mktemp /tmp/key.XXXXXX)
    CERT=$(mktemp /tmp/crt.XXXXXX)
    #echo -n "${CLIENT_KEY}" | base64 -d > ${KEY}
    #echo -n "${CLIENT_CERT}" | base64 -d > ${CERT}
    echo -n "${CLIENT_KEY}" > ${KEY}
    echo -n "${CLIENT_CERT}" > ${CERT}
    PARAMS="${PARAMS} --key ${KEY} --cert ${CERT}"
fi
echo "The command to run is curl ${PARAMS} ${XP_URL}/app/install"
curl ${PARAMS} ${XP_URL}/app/install
