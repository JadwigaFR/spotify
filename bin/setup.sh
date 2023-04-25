#!/usr/bin/env bash 

set -euo pipefail

# Detect the OS
case "$(uname -s)" in
    Linux*)     os=Linux;;
    Darwin*)    os=Mac;;
    CYGWIN*)    os=Windows;;
    MINGW*)     os=Windows;;
    *)          os="UNKNOWN"
esac

# Check if the OS is supported
if [ "$os" == "UNKNOWN" ]; then
    echo "Unsupported OS. Exiting..."
    exit 1
fi

echo "Detected OS: $os"

# Check if rbenv or rvm is installed
ruby_version_manager=""
if command -v rbenv &> /dev/null; then
    ruby_version_manager="rbenv"
fi
if command -v rvm &> /dev/null; then
    if [ -z "$ruby_version_manager" ]; then
        ruby_version_manager="rvm"
    else
        echo "Both 'rbenv' and 'rvm' are installed. Please choose one:"
        echo "1. rbenv"
        echo "2. rvm"
        read -e -p "Enter your choice (1/2): " choice
        if [ "$choice" == "1" ]; then
            ruby_version_manager="rbenv"
        elif [ "$choice" == "2" ]; then
            ruby_version_manager="rvm"
        else
            echo "Invalid choice. Exiting..."
            exit 1
        fi
    fi
fi

# Install ruby and a ruby version manager based on the OS and user choice, and then install the required Ruby version for the current project
if [ -z "$ruby_version_manager" ]; then
    if [ "$os" == "Linux" ]; then
        sudo apt update
        sudo apt install -y rbenv
        ruby_version_manager="rbenv"
    elif [ "$os" == "Mac" ]; then
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi
        brew install rbenv
        rbenv init
        ruby_version_manager="rbenv"
    elif [ "$os" == "Windows" ]; then
        echo "Please install ruby using the installer from 'https://rubyinstaller.org/' and then manually install 'rbenv' or 'rvm' by following the respective instructions."
        exit 1
    fi
fi

if [ "$ruby_version_manager" == "rbenv" ]; then
    eval "$(rbenv init -)"
    rbenv install 2.6.6
    export PATH="$(rbenv root)/shims:${PATH}"
    echo "export PATH=\"$(rbenv root)/shims:${PATH}\"" >> .bashrc
elif [ "$ruby_version_manager" == "rvm" ]; then
    rvm install 2.6.6
    export PATH="$PATH:$HOME/.rvm/bin"
    echo "export PATH=\"$PATH:$HOME/.rvm/bin\"" >> .bashrc
fi

echo "Installing dependencies..."
gem install bundler
bundle install

echo "Creating .sekrets file, please ask your developer to give you the secret"
if [[ ! -e .sekrets.key ]]; then
  echo > .sekrets.key
fi

chmod +x exe/spotiplay

echo "Please provide your spotify Username (to be found on: 'https://www.spotify.com/us/account/overview/'"
read -e -p "Username: " USERNAME
echo "username: $USERNAME" > config/credentials.yml

mkdir -p tmp/playlists