load("@d2l_rules_csharp//csharp:defs.bzl", "csharp_library")

csharp_library(
    name = "Demo",
    srcs = ["Class.cs"],
    target_frameworks = ["net472"],
    deps = [
        "@ExampleNupkg//:SomePackage",
        "@ExamplePackageFolder//:SomePackage",
    ],
)

csharp_library(
    name = "OldThing",
    srcs = ["Class.cs"],
    target_frameworks = ["net11"],
    include_stdrefs = False,
    deps = ["@ExamplePackageFolder//:SomePackage"],
)
