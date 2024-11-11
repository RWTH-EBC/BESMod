#!/bin/bash

# Set the download URL and destination directory
download_url="https://spawn.s3.amazonaws.com/builds/Spawn-light-0.4.3-7048a72798-win64.zip"
destination_dir="installed_dependencies/Buildings/Buildings/Resources/bin"

# Create the destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Download the Spawn binaries
echo "Downloading Spawn binaries..."
wget -q "$download_url" -O spawn_binaries.zip

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download Spawn binaries. Please check the download URL and try again."
  exit 1
fi

# Unzip the Spawn binaries
echo "Unzipping Spawn binaries..."
unzip -q spawn_binaries.zip -d "$destination_dir"

# Check if the unzip was successful
if [ $? -ne 0 ]; then
  echo "Failed to unzip Spawn binaries. Please check the permissions and try again."
  exit 1
fi

# Remove the downloaded zip file
rm spawn_binaries.zip

echo "Spawn binaries successfully installed at $destination_dir"