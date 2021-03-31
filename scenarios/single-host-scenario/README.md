# Single host scenarios

## What is this?

This repository contains docker-compose files to run the Niryo One Digital Twin service on a single host.

Note: please be sure that on the following requirements are fulfilled for the host:
- The host is running Ubuntu 16.04, 18.04 or 20.04
- Docker is installed (tutorial [here](https://docs.docker.com/engine/install/ubuntu/))
- Docker compose is isnstalled (tutorial [here](https://docs.docker.com/compose/install/))
- This repository is cloned in the host

This repo provides two options to run Niryo One Digital Twin service on a single host:
- centralized-stack: run the Niryo One Digital Twin service where the Niryo One Stack is deployed in a single container (tutorial [here](./centralized-stack/)).
- distributed-stack: run the Niryo One Digital Twin service where the Niryo One Stack is deployed in multiple containers (tutorial [here](./distributed-stack/)).
