#!/bin/bash

## set up variables
IMAGE=mecab-server
DATE=$(date +"%Y-%m-%d-%H%M%S")
CMD_GCLOUD=/opt/google-cloud-sdk/bin/gcloud
IMAGE_URL=$GCR_DOMAIN/$GCP_PROJECT_ID/peinan/$IMAGE

## set up gcp
echo $GCR_AUTH | base64 -d > $HOME/gcr-key.json
sudo $CMD_GCLOUD components update
sudo $CMD_GCLOUD auth activate-service-account --key-file $HOME/gcr-key.json
sudo $CMD_GCLOUD config set project $GCP_PROJECT_ID

# build
docker build \
  -t $IMAGE:$DATE \
  -t $IMAGE:latest \
  -t $IMAGE_URL:latest \
  .

## deploy to GCR
sudo $CMD_GCLOUD docker -- push $IMAGE_URL

## deploy to GAE
echo $GAE_AUTH | base64 -d > $HOME/gae-key.json
sudo $CMD_GCLOUD auth activate-service-account --key-file $HOME/gae-key.json
sudo $CMD_GCLOUD config set project $GCP_PROJECT_ID
sudo $CMD_GCLOUD app deploy --image-url $IMAGE_URL
sudo $CMD_GCLOUD app browse -s $IMAGE
