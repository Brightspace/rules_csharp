load("@d2l_rules_csharp//csharp:defs.bzl", "csharp_library")

csharp_library(
    name = "Demo",
    srcs = ["Class.cs"],
    deps = [
        "@ExampleNupkg//:SomePackage",
        "@ExamplePackageFolder//:SomePackage",
    ],
)

csharp_library(
    name = "MultiTarget_DepOnPackageThatHasWeirdFrameworks",
    target_frameworks = ["net20", "net40", "net48"],
    srcs = ["Class.cs"],
    deps = ["@ExamplePackageFolder//:SomePackage"],
)
