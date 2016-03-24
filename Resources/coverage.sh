#!/bin/bash

set -e

coverage_dir="$1"
profdata=$(find "$coverage_dir" -name "*.profdata" | head -1)
executable=$(find "$coverage_dir" -type f -name "Mapper" | head -1)
xcrun llvm-cov show -instr-profile "$profdata" "$executable" > "coverage.txt"
