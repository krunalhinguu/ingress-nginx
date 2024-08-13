#!/bin/sh

UPSTREAM_REPO_OWNER="kubernetes"; UPSTREAM_REPO_NAME="ingress-nginx"; FORKED_REPO_OWNER="rancher"; FORKED_REPO_NAME="ingress-nginx"

# step 1
latest_upstream_release=$(curl -s https://api.github.com/repos/$UPSTREAM_REPO_OWNER/$UPSTREAM_REPO_NAME/releases | jq -r '[.[] | select(.tag_name | startswith("controller"))] | .[0].tag_name')

# step 2
latest_forked_release=$(curl -s https://api.github.com/repos/$FORKED_REPO_OWNER/$FORKED_REPO_NAME/releases | jq -r '[.[] | select(.tag_name)] | .[0].tag_name')

# Fetch only the version from the release tag
latest_upstream_version=$(echo $latest_upstream_release | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
latest_forked_version=$(echo $latest_forked_release | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

if [ "$(printf '%s\n' "$latest_forked_version" "$latest_upstream_version" | sort -V | head -n1)" != "$latest_upstream_version" ]; then
    new_release="true" 
else
    new_release="false"
fi

echo "new_release=$new_release"