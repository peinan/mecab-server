#!/bin/bash

## set up variables
IMAGE=mecab-server
DATE=$(date +"%Y-%m-%d-%H%M%S")
gcloud=/opt/google-cloud-sdk/bin/gcloud

## set up gcp
echo $ACCT_AUTH | base64 -d > $HOME/gcp-key.json
sudo $gcloud components update
sudo $gcloud auth activate-service-account --key-file $HOME/gcp-key.json
sudo $gcloud config set project $GCP_PROJECT_ID

# build
docker build . \
  -t $IMAGE:$DATE \
  -t $IMAGE:latest \
  -t $GCR_URL/$GCP_PROJECT_ID/peinan/$IMAGE:latest

## deploy to GCR and GAE
# sudo $gcloud app deploy
# sudo $gcloud app browse -s $IMAGE
