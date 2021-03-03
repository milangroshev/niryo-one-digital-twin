#!/bin/bash

echo "Stopping and removing pre-existing zenoh routers..."
docker stop zenoh_router
docker rm zenoh_router

echo "Running zenoh router..."
docker run  -e RUST_LOG=debug--init -p 7447:7447/tcp -p 7447:7447/udp -p 8000:8000/tcp  --name zenoh_router -d --network=zenoh-replay-network eclipse/zenoh:latest 

echo "Adding storage /demo/sample/**"
curl -X PUT -H 'content-type:application/properties' -d 'path_expr=/mystorage/**' http://localhost:8000/@/router/local/plugin/storages/backend/memory/storage/my-storage

echo "Checking if the storage was created"
curl 'http://localhost:8000/@/router/local/**/storage/*' # check storage
