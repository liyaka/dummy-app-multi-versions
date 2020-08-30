#!/bin/bash

BUILD_NUMBER=${BUILD_NUMBER:-1}
REGISTRY_URL=${REGISTRY_URL:-}

echo "Set version"
VERSION=`cat version-base.txt`.${BUILD_NUMBER}
echo "Version is ${VERSION}"
echo ${VERSION} > version.txt

echo "Build docker image"
docker build -t ${REGISTRY_URL}dummy-app:${VERSION} .

echo "Push docker image"
#docker push ${REGISTRY_URL}/dummy-app:${VERSION}
