load("@d2l_rules_csharp//csharp:defs.bzl", "csharp_library")

csharp_library(
    name = "Demo",
    srcs = ["Class.cs"],
    target_frameworks = ["netcoreapp3.0"],
    deps = [
        "@ExampleNupkg//:SomePackage",
        "@ExamplePackageFolder//:SomePackage",
    ],
)

csharp_library(
    name = "OldThing",
    srcs = ["Class.cs"],
    include_stdrefs = False,
    target_frameworks = ["net11"],
    deps = ["@ExamplePackageFolder//:SomePackage"],
)
