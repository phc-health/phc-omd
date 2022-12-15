#!/usr/bin/env bash
set -euo pipefail

# docker build . -f ./Dockerfile.phc -t metadata
# docker run --rm -it --entrypoint=bash metadata

docker build \
  --target=artifact \
  -f ./Dockerfile.phc \
  --output type=local,dest=./dist/ .
