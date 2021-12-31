#!/usr/bin/env bash
set -euo pipefail

echo "Installing ruby 2.6..."
sudo apt update
sudo apt install -y rbenv
rbenv install 2.6.6

export PATH=~/.rbenv/shims:$PATH
echo "export PATH=~/.rbenv/shims:\$PATH" >> ~/.bashrc

echo "Installing dependencies..."
gem install bundler
bundle install

echo "Creating .sekrets file, please ask your developer to give you the secret"
if [[ ! -e .sekrets.key ]]; then
  echo > .sekrets.key
fi

echo "Making spotiplay executable from everywhere in machine..."
chmod +x exe/spotiplay

echo "Please provide your spotify Username (to be found on: 'https://www.spotify.com/us/account/overview/'"
read -e -p "Username: " USERNAME
echo "username: $USERNAME" > config/credentials.yml
