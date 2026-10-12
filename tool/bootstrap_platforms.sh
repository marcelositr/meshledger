#!/bin/sh
set -eu

# Generate the native runner projects expected by Flutter. This is needed
# because the repository keeps the shared Dart foundation small during early
# development and does not yet commit generated platform runner directories.
if ! command -v flutter >/dev/null 2>&1; then
  printf '%s\n' "Error: Flutter SDK was not found on PATH." >&2
  exit 127
fi

flutter create \
  --project-name meshledger \
  --platforms=android,ios,windows,linux,macos \
  --no-pub \
  .
