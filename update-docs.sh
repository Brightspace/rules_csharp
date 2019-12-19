#!/bin/bash

set -euo pipefail

bazel build //docs/...
cp bazel-bin/docs/*.md docs/