#!/bin/bash
set -euo pipefail
# --- begin runfiles.bash initialization ---
if [[ ! -d "${RUNFILES_DIR:-/dev/null}" && ! -f "${RUNFILES_MANIFEST_FILE:-/dev/null}" ]]; then
    if [[ -f "$0.runfiles_manifest" ]]; then
      export RUNFILES_MANIFEST_FILE="$0.runfiles_manifest"
    elif [[ -f "$0.runfiles/MANIFEST" ]]; then
      export RUNFILES_MANIFEST_FILE="$0.runfiles/MANIFEST"
    elif [[ -f "$0.runfiles/bazel_tools/tools/bash/runfiles/runfiles.bash" ]]; then
      export RUNFILES_DIR="$0.runfiles"
    fi
fi
if [[ -f "${RUNFILES_DIR:-/dev/null}/bazel_tools/tools/bash/runfiles/runfiles.bash" ]]; then
  source "${RUNFILES_DIR}/bazel_tools/tools/bash/runfiles/runfiles.bash"
elif [[ -f "${RUNFILES_MANIFEST_FILE:-/dev/null}" ]]; then
  source "$(grep -m1 "^bazel_tools/tools/bash/runfiles/runfiles.bash " \
            "$RUNFILES_MANIFEST_FILE" | cut -d ' ' -f 2-)"
else
  echo >&2 "ERROR: cannot find @bazel_tools//tools/bash/runfiles:runfiles.bash"
  exit 1
fi
# --- end runfiles.bash initialization ---
# --- begin expand_template variables ---
_resx="{ResXFile}"
_resx_manifest="{ResXManifest}"
_csproj_template="{CsProjTemplate}"
_net_framework="{NetFramework}"
_dotnet_exe="{DotNetExe}"
# --- end expand_template variables ---
csproj_file="${CsProjFile}"

csproj_template="$(rlocation ${_csproj_template})"
resx_file="$(rlocation ${_resx})"

BazelResXFramework="${_net_framework}"
BazelResXFile="$(realpath --relative-base="${csproj_file}" "${resx_file}")"
BazelResXManifestResourceName="${_resx_manifest}"
export BazelResXFile BazelResXFramework BazelResXManifestResourceName

envsubst < "${csproj_template}" > "${csproj_file}"

dotnet_exe="$(rlocation ${_dotnet_exe})"
if [[ "$OSTYPE" == "linux-gnu" || "$OSTYPE" == "darwin"* ]]; then
    ${dotnet_exe} build $@ ${csproj_file}
else
    dotnet_path=$(echo "/$dotnet_exe" | sed 's/\\/\//g' | sed 's/://')
    ${dotnet_path} build $@ ${csproj_file}
fi