#!/bin/bash

# Replace environment variables in kong.yml
envsubst < /kong/kong.yml > /tmp/kong.yml
cp /tmp/kong.yml /kong/kong.yml
chown kong:kong /kong/kong.yml

# Start Kong
exec /docker-entrypoint.sh kong docker-start
