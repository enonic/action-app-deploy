#!/usr/bin/env bash

set -e

enonic app install --file ${APP_JAR:-./build/libs/*.jar}
