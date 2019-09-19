workspace(name = "d2l_rules_csharp")

load(
    "@d2l_rules_csharp//csharp:defs.bzl",
    "csharp_register_toolchains",
    "csharp_repositories",
    "import_nuget_package",
)

csharp_repositories()

csharp_register_toolchains()

# These are some examples.
# Should this go here? Should we have a WORKSPACE inside csharp/ and one in
# examples/?

import_nuget_package(
    name = "ExamplePackageFolder",
    dir = "examples/import_nuget_package/ExamplePackageFolder",
)

import_nuget_package(
    name = "ExampleNupkg",
    file = "examples/import_nuget_package/Example.nupkg",
    sha256 = "a658761334ffab1773c10dc53c7aa964f61a793963bb8111d416d2e1e1e95635",
)
