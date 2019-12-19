load("@io_bazel_stardoc//stardoc:stardoc.bzl", "stardoc")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

bzl_library(
    name = "bazel_dependencies",
    srcs = [
        "@bazel_tools//tools:bzl_srcs",
    ],
)

bzl_library(
    name = "rules_csharp",
    srcs = [
        "//csharp/private:bzl_srcs",
    ],
)

stardoc(
    name = "core",
    out = "APIReference.md",
    input = "//csharp:defs.for_docs.bzl",
    tags = ["fix-windows"],
    deps = [
        ":rules_csharp",
        ":bazel_dependencies",
    ],
)
