#!/bin/bash

# Replace environment variables in kong.yml.template
envsubst < /kong/kong.yml.template > /tmp/kong.yml
cp /tmp/kong.yml /kong/kong.yml
chown kong:kong /kong/kong.yml

# Start Kong
exec /docker-entrypoint.sh kong docker-start
