#!/usr/bin/env bash
version=$(curl -sX GET "https://pkgs.alpinelinux.org/packages?name=tinyproxy&branch=v3.20&arch" | grep -oP '(?<=<td class="version">)[^<]*')
version="${version%%_*}"
version="${version%%-*}"
printf "%s" "${version}"
