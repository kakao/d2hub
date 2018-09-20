#!/bin/sh
if [ $# != 2 ]; then
  echo "please input \"version\" \"chronos basic auth\" "
  echo "ex) $0 v1.0 username:password"
  exit 1
fi

VERSION=$1
CHRONOS_BASIC_AUTH=$2
IMAGE_NAME=d2hub.com/d2hub/d2hub
REPLACE_IMAGE_NAME=$(echo $IMAGE_NAME | sed -e 's/\//'"\\\\\/"'/g')
CURRENT_IMAGE=$IMAGE_NAME:$VERSION
LATEST_IMAGE=$IMAGE_NAME:latest

cat marathon_template.json | sed -e 's/\$VERSION\$/'"${VERSION}"'/g;s/\$IMAGE_NAME\$/'"${REPLACE_IMAGE_NAME}"'/g;s/\$CHRONOS_BASIC_AUTH\$/'"${CHRONOS_BASIC_AUTH}"'/g' > marathon.json
docker build -t "$CURRENT_IMAGE" .
docker tag "$CURRENT_IMAGE" "$LATEST_IMAGE"
docker push "$CURRENT_IMAGE"
docker push "$LATEST_IMAGE"