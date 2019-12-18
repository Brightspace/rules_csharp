#!/bin/bash
TFM="net472"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -euo pipefail

TARGET="$DIR/.nuget/ReferenceAssemblies"
SOURCE="$TARGET/Microsoft.NETFramework.ReferenceAssemblies.${TFM}.1.0.0"
GENERATED="${DIR}/csharp/private/frameworks/${TFM}.BUILD"

rm -rf "${TARGET}"
nuget install Microsoft.NETFramework.ReferenceAssemblies -OutputDirectory "${TARGET}" -Framework "${TFM}"

cd tools
bazel build ///frameworks:generator
# cp bazel-bin/docs/*.md docs/
bazel run ///frameworks:generator -- "${SOURCE}" "${GENERATED}"
# Run buildifier on the target