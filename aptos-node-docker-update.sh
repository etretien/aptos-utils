#!/bin/bash

echo "Updating Aptos validator node"

echo "Stopping containter"
docker-compose down

echo "Removing data volume"
docker volume rm -f aptos-docker_db

echo "Removing waypoint.txt and genesis.blob"
rm -f waypoint.txt genesis.blob

echo "Downloading new waypoint and genesis files"
wget https://devnet.aptoslabs.com/genesis.blob https://devnet.aptoslabs.com/waypoint.txt

echo "Pulling updated Docker image"
docker pull docker.io/aptoslab/validator:devnet

echo "Starting new container"
docker-compose up -d

echo "Checking initial synchronization (result should be non-zero):"
echo `curl 127.0.0.1:9101/metrics 2> /dev/null | grep "aptos_state_sync_version{.*\"synced\"}" | awk '{print $2}'`
