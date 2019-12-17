load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load(
    "@d2l_rules_csharp//csharp:defs.bzl",
    "csharp_binary",
)

# run with bazel run ///frameworks:generator -- $PWD/frameworks/ReferenceAssemblies/Microsoft.NETFramework.ReferenceAssemblies.net48.1.0.0/
csharp_binary(
    name = "generator",
    srcs = glob(["**/*.cs"]),
    target_frameworks = ["net48"],
    deps = [
        "@System.Collections.Immutable//:System.Collections.Immutable",
        "@net//:netstandard",
    ],
)
