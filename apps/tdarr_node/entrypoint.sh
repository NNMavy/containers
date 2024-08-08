#!/usr/bin/env bash

cd /app/Tdarr_Node || exit 1

if [ -d "/etc/services.d/tdarr_server" ] && [ "$internalNode" = true ]; then \
    echo "Starting Tdarr_Node"
    exec ./Tdarr_Node
fi

if [ ! -d "/etc/services.d/tdarr_server" ]; then \
    echo "Starting Tdarr_Node"
    exec ./Tdarr_Node
fi
