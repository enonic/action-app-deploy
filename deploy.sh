#!/usr/bin/env bash

set -e

PARAMS="-X POST -f -s -S -o - -u ${XP_USERNAME}:${XP_PASSWORD}" # Initializing arguments for curl command. 

if [ "$CLIENT_KEY" != "" ] && [ "$CLIENT_CERT" != "" ]; then    #Add the MTLS client key and cert in the argumetns list for the curl command.
    echo "Using mTLS to establish secure connection with the server"
    KEY=$(mktemp /tmp/key.XXXXXX)
    CERT=$(mktemp /tmp/crt.XXXXXX)
    echo -n "${CLIENT_KEY}" > ${KEY}
    echo -n "${CLIENT_CERT}" > ${CERT}
    PARAMS="${PARAMS} --key ${KEY} --cert ${CERT}"
fi

app=`find . -wholename ${APP_JAR:-"./build/libs/*.jar"}` # Use APP_JAR if set or default to ./build/libs/*.jar
num_files=`echo "$app" | wc -w`

if (( $num_files != 1 ));
then
    # Failed to find just 1 file, print error and exit
    echo "This action needs exactly 1 jar but it found $num_files!"
    for a in $app; do  #Display the .jar files found
        echo "  $a"
    done
    echo "Set 'app_jar' parameter so 1 and only 1 jar is selected!"
    exit 1
else
        # We have a single jar, set it up for curl
        PARAMS="${PARAMS} -F file=@${app}"
fi

curl ${PARAMS} ${XP_URL}/app/install        #run curl with the parameters set above 
