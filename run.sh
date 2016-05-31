#!/bin/sh

#rebuild image
docker-compose down
docker-compose up --build -d
