#!/bin/bash
TFM="net48"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euo pipefail

SOURCE="$DIR/tools/frameworks/ReferenceAssemblies/Microsoft.NETFramework.ReferenceAssemblies.${TFM}.1.0.0"
GENERATED="${DIR}/${TFM}.BUILD"

cd tools
bazel build ///frameworks:generator
# cp bazel-bin/docs/*.md docs/
bazel run ///frameworks:generator -- "${SOURCE}" "${GENERATED}"