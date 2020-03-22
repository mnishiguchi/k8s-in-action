# [Chapter 02] Understanding containers

## DEMO

```sh
# Building the image
docker build \
  -t kubia:latest \
  .

# List locally stored images
docker images | head

# Show the layers of an image
docker history kubia:latest

# Run the container in the background from an image
docker run \
  --name kubia-container \
  -p 1234:8080 \
  -d \
  kubia
# 6a549cc033b6bf980ee665c127cf8a2ab6d1c326db060837e3b5b2bbd0b8606c

# Access the app with browser or curl
curl http://localhost:1234
# You've hit 6a549cc033b6

# List all running containers with their basic info
docker ps

# Print JSON containing details about a container
docker inspect kubia-container

# Display the application log
docker logs -f kubia-container
```

## Distributing container images

### Tagging an image

```sh
docker images | head
# REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
# kubia                                     latest              3cdc98e367f4        7 hours ago         916MB

docker tag kubia mnishiguchi/kubia

docker images | head
# REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
# kubia                                     latest              3cdc98e367f4        7 hours ago         916MB
# mnishiguchi/kubia                         latest              3cdc98e367f4        7 hours ago         916MB
```

### Pushing the image to Docker Hub

```sh
# Log in to Docker Hub
docker login \
  --username mnishiguchi \
  --password-stdin mypassword \
  docker.io

docker push mnishiguchi/kubia
```

## Stopping and deleting a container

```sh
# Stop a running container
docker stop kubia-container

# Start a stopped container
docker start kubia-container

# Delete a container that is stored locally
docker rm kubia-container

# Delete an image that is stored locally
docker tmi kubia:latest

# Remove all the dangling images
docker image prune
```

## Running a shell inside an existing container

```sh
docker exec -it kubia-container bash
```
