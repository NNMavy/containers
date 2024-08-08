#!/usr/bin/env bash

echo "Starting Tdarr_Server"

cd /app/Tdarr_Server || exit 1

exec ./Tdarr_Server
