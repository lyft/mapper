from __future__ import print_function
import json
import sys

module = sys.argv[1]
coverage = json.load(sys.stdin)
for blob in coverage:
    if blob["name"] == module:
        print(blob["lineCoverage"])
        sys.exit(0)

print("Module '{}' not found in '{}'".format(module, json.dumps(coverage)),
      file=sys.stderr)
sys.exit(1)
