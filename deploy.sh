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
	echo "No app name specified, looking for .jar file under build/libs"
	echo $(pwd)
	#echo "${{ github.action_path }}"
	ls -lah ${{ github.action_path }}
	app=$(find ./build/libs  -type f -name "*.jar")
	if [ -z "$app" ];
	then
		echo "There is no jar file, under build/libs"
	else #If it has found one or more .jar files under build/libs
		num_files=$(echo "$app" | wc -w)
        	if (( $num_files > 1 ));
        	then
                	echo "More than one jar file under build/libs, please specify which one to deploy in action input." 
        	else
			PARAMS="${PARAMS} -F file=@${app}"
			echo "Deploying:  $app"
			echo "going to run curl ${PARAMS} ${XP_URL}/app/install"
	        fi
	fi
	
else
	echo "App name and path specified"
	app="$(find . -wholename ${APP_JAR} | head -n 1)"
	if [ "$app" != "" ]; then
		PARAMS="${PARAMS} -F file=@${app}"
		echo "going to run. curl ${PARAMS} ${XP_URL}/app/install"
	else
		echo "Unable to find the specified app/PATH."
	fi
fi
