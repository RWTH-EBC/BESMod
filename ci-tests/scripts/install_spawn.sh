#!/bin/bash

# Set the download URL and target subdirectory structure
download_url="https://spawn.s3.amazonaws.com/custom/Spawn-light-0.6.0-9f1b36b00b-Linux.tar.gz"
destination_dir="installed_dependencies/Buildings/Buildings/Resources/bin/spawn-0.4.3-7048a72798/linux64/bin"

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

# Check the name of the binary and rename if necessary
binary_path="$destination_dir/spawn-0.4.3-7048a72798"
if [ ! -f "$binary_path" ]; then
  # Find the actual binary name in the directory
  actual_binary_name=$(ls "$destination_dir" | grep 'spawn' | head -n 1)
  if [ -n "$actual_binary_name" ]; then
    echo "Renaming $actual_binary_name to spawn-0.4.3-7048a72798"
    mv "$destination_dir/$actual_binary_name" "$binary_path"
  else
    echo "Spawn binary not found in $destination_dir."
    exit 1
  fi
fi

echo "Spawn binaries successfully installed at $destination_dir"