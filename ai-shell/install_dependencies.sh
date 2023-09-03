#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install dependencies on Linux (Debian-based)
install_dependencies_linux() {
  if ! command_exists curl; then
    echo "curl is not installed. Installing..."
    if sudo apt-get install -y curl; then
      echo "curl has been installed successfully."
    else
      echo "Failed to install curl. Please install it manually."
      exit 1
    fi
  fi

  if ! command_exists jq; then
    echo "jq is not installed. Installing..."
    if sudo apt-get install -y jq; then
      echo "jq has been installed successfully."
    else
      echo "Failed to install jq. Please install it manually."
      exit 1
    fi
  fi
}

# Function to install dependencies on macOS using Homebrew
install_dependencies_macos() {
  if ! command_exists curl; then
    echo "curl is not installed. Installing..."
    if brew install curl; then
      echo "curl has been installed successfully."
    else
      echo "Failed to install curl. Please install it manually."
      exit 1
    fi
  fi

  if ! command_exists jq; then
    echo "jq is not installed. Installing..."
    if brew install jq; then
      echo "jq has been installed successfully."
    else
      echo "Failed to install jq. Please install it manually."
      exit 1
    fi
  fi
}

# Function to install dependencies on CentOS
install_dependencies_centos() {
  if ! command_exists curl; then
    echo "curl is not installed. Installing..."
    if sudo yum install -y curl; then
      echo "curl has been installed successfully."
    else
      echo "Failed to install curl. Please install it manually."
      exit 1
    fi
  fi

  if ! command_exists jq; then
    echo "jq is not installed. Installing..."
    if sudo yum install -y jq; then
      echo "jq has been installed successfully."
    else
      echo "Failed to install jq. Please install it manually."
      exit 1
    fi
  fi
}

# Check the operating system and install dependencies accordingly
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  install_dependencies_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
  install_dependencies_macos
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  echo "Windows is not supported. Please install curl and jq manually."
  exit 1
else
  echo "Unsupported operating system: $OSTYPE. Please install curl and jq manually."
  exit 1
fi

# Continue with your script here

