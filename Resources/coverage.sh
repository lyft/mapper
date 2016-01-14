#!/bin/bash

set -e

profdata="$1"
coverage_dir="$2"
framework=$(find "$coverage_dir" -name "*.framework")
xcrun llvm-cov show -instr-profile "$profdata" "$framework/Mapper" > "coverage.txt"
