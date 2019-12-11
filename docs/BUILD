load("@io_bazel_stardoc//stardoc:stardoc.bzl", "stardoc")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

bzl_library(
    name = "bazel_dependencies",
    srcs = [
        "@bazel_tools//tools:bzl_srcs",
    ],
)

bzl_library(
    name = "bazel_csharp",
    srcs = [
        "//csharp:bzl_srcs",
    ],
)

stardoc(
    name = "core",
    out = "APIReference.md",
    input = "//csharp:defs.for_docs.bzl",
    tags = ["fix-windows"],
    deps = [
        ":bazel_csharp",
        ":bazel_dependencies",
    ],
)
