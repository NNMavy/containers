#!/usr/bin/env bash
version=$(curl -sX GET "https://api.github.com/users/haveagitgat/packages/container/tdarr/versions" | jq 'map( select( .metadata.container.tags[] | test("^latest$")  ) | .metadata.container.tags[] )' | jq 'map( select( index("latest") | not ) )'  | jq --raw-output '.[0]')
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
