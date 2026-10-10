#!/usr/bin/env bash
set -euo pipefail

KEY_ID="422090E0792950AC9BA3BF3C90FCFE121B1B7061"

mkdir -p dists/stable/main/binary-amd64

dpkg-scanpackages --arch amd64 pool /dev/null \
  | gzip -9n > dists/stable/main/binary-amd64/Packages.gz

apt-ftparchive -c apt-ftparchive.conf release dists/stable \
  > dists/stable/Release

gpg --batch --yes --local-user "$KEY_ID" \
  --clearsign -o dists/stable/InRelease dists/stable/Release

gpg --batch --yes --local-user "$KEY_ID" \
  --armor --detach-sign -o dists/stable/Release.gpg \
  dists/stable/Release

echo "Repository metadata generated and signed successfully."
