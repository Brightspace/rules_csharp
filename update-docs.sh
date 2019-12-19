#!/bin/bash

set -euo pipefail

bazel build //docs/...

# Copy the file, ignoring the permissions inside bazel-bin
cat bazel-bin/docs/APIReference.md > docs/APIReference.md
