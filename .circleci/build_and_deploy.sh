#!/bin/bash

## build docker container
IMAGE=mecab-server
DATE=$(shell date +"%Y-%m-%d-%H%M%S")
docker build . \
  -t $IMAGE:$DATE \
  -t $IMAGE:latest \
  -t $GCR_URL/$GCP_PROJECT_ID/peinan/$IMAGE

## set up gcp
echo $ACCT_AUTH | base64 -d > $HOME/gcp-key.json
sudo gcloud components update
sudo gcloud auth activate-service-account --key-file $HOME/gcp-key,json
sudo gcloud config set project $GCP_PROJECT_ID

## deploy to GCR and GAE
sudo gcloud 
sudo gcloud app deploy
sudo gcloud app browse -s $IMAGE
