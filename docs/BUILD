load("@io_bazel_stardoc//stardoc:stardoc.bzl", "stardoc")

stardoc(
    name = "core",
    out = "APIReference.md",
    input = "//csharp:defs.for_docs.bzl",
    deps = [
        "//csharp:bzl",
    ],
)
