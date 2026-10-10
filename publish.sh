#!/usr/bin/env bash
set -euo pipefail

KEY_ID="422090E0792950AC9BA3BF3C90FCFE121B1B7061"

# Ensure directories exist
mkdir -p dists/stable/main/binary-amd64

# Generate Packages index
# We run this from the root to ensure 'Filename' paths start with 'pool/'
dpkg-scanpackages --arch amd64 pool /dev/null > dists/stable/main/binary-amd64/Packages

# Generate compressed Packages index
gzip -9n -c dists/stable/main/binary-amd64/Packages > dists/stable/main/binary-amd64/Packages.gz

# Generate Release file
# apt-ftparchive uses the config to set Origin, Label, etc.
apt-ftparchive -c apt-ftparchive.conf release dists/stable > dists/stable/Release

# Sign the Release file to create InRelease
gpg --batch --yes --local-user "$KEY_ID" --clearsign -o dists/stable/InRelease dists/stable/Release

# Create the detached GPG signature for the Release file
gpg --batch --yes --local-user "$KEY_ID" --armor --detach-sign -o dists/stable/Release.gpg dists/stable/Release

echo "Repository metadata generated and signed successfully."
