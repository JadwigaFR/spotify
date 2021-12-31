#!/usr/bin/env bash
set -euo pipefail

echo "Installing ruby 2.7..."
sudo apt update
#sudo apt install -y ruby2.7 bundler

echo "Installing dependencies..."
#bundle install
# username: uxe7uzzrup7n1583r5qbrhuje
echo "Creating .sekrets file, please ask your developer to give you the secret"
if [[ ! -e .sekrets.key ]]; then
  echo > .sekrets.key
fi
# 5Z4TnTVGh%oareuI6NFh#P

echo "Making spotiplay executable from everywhere in machine..."
chmod +x exe/spotiplay

echo "Please provide your spotify Username (to be found on: 'https://www.spotify.com/us/account/overview/'"
read -e -p "Username: " USERNAME
echo "username: $USERNAME" > config/credentials.yml


# fix dependencies
# add PATH
# test from root
# test in the virtual machine
