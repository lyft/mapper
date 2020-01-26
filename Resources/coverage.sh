#!/bin/bash

set -e
set -o pipefail
set -u

coverage_dir="$1"
result_bundle="$(find "$coverage_dir" -name "*.xcresult")"

result="$(xcrun xccov view \
  --report \
  --only-targets \
  --json \
  "$result_bundle" \
  | python Resources/get-coverage.py Mapper.framework)"

if [ "$result" != "1" ]; then
  echo "Coverage is $result, should be 1"
  exit 1
fi
