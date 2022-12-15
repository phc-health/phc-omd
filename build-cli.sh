#!/usr/bin/env bash
set -euo pipefail

readonly DIST_DIR="./dist"

warn() { >&2 echo -e "$@"; }

usage() {
  local script_name
  script_name="$(basename "$0")"

  warn "Usage: ${script_name} [-h] | [-p]"
  warn
  warn "\t-p)  creates a github release and pushes the files in /dist"
  warn "\t-h)  shows this help text"
  exit "$1"
}

push() {
  version="$(find ${DIST_DIR}/*.whl -type f -exec basename {} \; | awk -F'-' '{print $2}')"
  echo "Publishing release $version"
  gh release create --generate-notes "$version" dist/*
}

main() {
  local push=false

  while getopts ph opt; do
    case $opt in
      p)  push=true  ;;
      h)  usage 0   ;;
      *)  usage 2   ;;
    esac
  done

  rm -rf "${DIST_DIR:?expected}"/* || true
  docker build \
    --target=artifact \
    -f ./Dockerfile \
    --output type=local,dest="${DIST_DIR}/" .

  if $push; then
    push
  fi
}

main "$@"
