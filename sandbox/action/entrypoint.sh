#!/bin/bash
set -e

cd /github/workspace

echo "XP_URL: ${ENONIC_CLI_REMOTE_URL}"
echo "XP_USERNAME: ${XP_USERNAME}"
echo "XP_PASSWORD: ${XP_PASSWORD}"
echo "APP_JAR: ${APP_JAR}"
echo "CLIENT_KEY: ${CLIENT_KEY}"
echo "CLIENT_CERT: ${CLIENT_CERT}"
echo "CRED_FILE: ${CRED_FILE}"

ENONIC_CLI_CMD="app install"

if [ "$XP_USERNAME" != "" ] && [ "$XP_PASSWORD" != "" ] && [ "$CRED_FILE" == "" ]; then
    echo "Using a basic token to authenticate with the server"
    ENONIC_CLI_CMD="${ENONIC_CLI_CMD} --auth ${XP_USERNAME}:${XP_PASSWORD}"
fi

if [ "$CRED_FILE" != "" ]; then
  echo "Using Service Account to authenticate with the server"
  SERVICE_ACCOUNT_KEY_FILE=$(mktemp /tmp/service-account-XXXXXX.json)
  echo -n "${CRED_FILE}" > "${SERVICE_ACCOUNT_KEY_FILE}"

  ENONIC_CLI_CMD="${ENONIC_CLI_CMD} --cred-file ${SERVICE_ACCOUNT_KEY_FILE}"
fi

if [ "$CLIENT_KEY" != "" ] && [ "$CLIENT_CERT" != "" ]; then
    echo "Using mTLS to establish secure connection with the server"
    KEY=$(mktemp /tmp/key.XXXXXX)
    CERT=$(mktemp /tmp/crt.XXXXXX)
    echo -n "${CLIENT_KEY}" > "${KEY}"
    echo -n "${CLIENT_CERT}" > "${CERT}"

    ENONIC_CLI_CMD="${ENONIC_CLI_CMD} --client-key ${KEY} --client-cert ${CERT}"
fi

# Use APP_JAR if set or default to ./build/libs/*.jar
app=$(find . -wholename "${APP_JAR:-"./build/libs/*.jar"}")

echo "Found app jar: $app"
ENONIC_CLI_CMD="${ENONIC_CLI_CMD} --file ${app}"

#num_files=$(echo "$app" | wc -w)
#
#if (( num_files != 1 )); then
#    # Failed to find just 1 file, print error and exit
#    echo "This action needs exactly 1 jar but it found $num_files!"
#    for a in $app; do  # Display the .jar files found
#        echo "  $a"
#    done
#    echo "Set 'app_jar' parameter so 1 and only 1 jar is selected!"
#    exit 1
#else
#   echo "Found app jar: $app"
#   ENONIC_CLI_CMD="${ENONIC_CLI_CMD} --file ${app}"
#fi

echo "$ENONIC_CLI_CMD"

enonic --version

enonic ${ENONIC_CLI_CMD}
