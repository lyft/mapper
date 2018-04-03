#!/bin/bash

set -e
set -o pipefail
set -u

coverage_dir="$1"
profdata="$(find "$coverage_dir" -name "*.xccovreport")"

result="$(xcrun xccov view \
  --only-targets \
  --json \
  "$profdata" \
  | python Resources/get-coverage.py Mapper.framework)"

if [ "$result" -ne "1" ]; then
  echo "Coverage is $result, should be 1"
  exit 1
fi
