# Use this to get the reference files for each framework
nuget install Microsoft.NETFramework.ReferenceAssemblies -OutputDirectory ReferenceAssemblies -Framework net11

# Then use this as a bazel run tool
# This will:
#   Download the nuget package for the specified frameworks
#   Iterate through the directories of these files (runfiles)
#   Emit a BUILD file containing all of the contents


# We will need to split out the work for declaring Skylark into something else
# As that will need to be its own open source framework (bundled into rules_csharp of course)