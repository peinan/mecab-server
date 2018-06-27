#!/bin/bash

## set up variables
IMAGE=mecab-server
DATE=$(date +"%Y-%m-%d-%H%M%S")
CMD_GCLOUD=/opt/google-cloud-sdk/bin/gcloud
GCR_URL=$GCR_DOMAIN/$GCP_PROJECT_ID/peinan/$IMAGE

## set up gcp
echo $ACCT_AUTH | base64 -d > $HOME/gcp-key.json
sudo $CMD_GCLOUD components update
sudo $CMD_GCLOUD auth activate-service-account --key-file $HOME/gcp-key.json
sudo $CMD_GCLOUD config set project $GCP_PROJECT_ID

# build
docker build \
  -t $IMAGE:$DATE \
  -t $IMAGE:latest \
  -t $GCR_URL:latest \
  .

## deploy to GCR and GAE
sudo $CMD_GCLOUD docker -- push $GCR_URL
sudo $CMD_GCLOUD app deploy
sudo $CMD_GCLOUD app browse -s $IMAGE
