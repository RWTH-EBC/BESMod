#!/bin/bash

# Set the download URL and target subdirectory structure
download_url="https://spawn.s3.amazonaws.com/custom/Spawn-light-0.5.0-ab07bde9bb-Linux.tar.gz"
destination_dir="installed_dependencies/Buildings/Buildings/Resources/bin/spawn-0.5.0-ab07bde9bb/linux64/bin"

# Create the destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Download the Spawn binaries
echo "Downloading Spawn binaries..."
wget -q "$download_url" -O spawn_binaries.tar.gz

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download Spawn binaries. Please check the download URL and try again."
  exit 1
fi

# Extract the Spawn binaries
echo "Extracting Spawn binaries..."
tar -xzf spawn_binaries.tar.gz -C "$destination_dir" --strip-components=2

# Check if the extraction was successful
if [ $? -ne 0 ]; then
  echo "Failed to extract Spawn binaries. Please check the permissions and try again."
  exit 1
fi

# Remove the downloaded tar file
rm spawn_binaries.tar.gz

# Ensure all extracted binaries have execute permissions
echo "Setting execute permissions for Spawn binaries..."
chmod +x "$destination_dir"/*

# Set the SPAWNPATH environment variable to the destination directory
export SPAWNPATH="$(pwd)/installed_dependencies/Buildings/Buildings/Resources/bin/spawn-0.5.0-ab07bde9bb/linux64/bin"

# Add the SPAWNPATH to PATH temporarily for this session
export PATH="${PATH}:${SPAWNPATH}"

# Confirm the environment variables
echo "SPAWNPATH is set to: $SPAWNPATH"
echo "PATH is set to: $PATH"

echo "Spawn binaries successfully installed at $destination_dir"