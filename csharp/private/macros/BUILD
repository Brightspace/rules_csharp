load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

bzl_library(
    name = "bazel_tools_rules",
    srcs = ["@bazel_tools//tools:bzl_srcs"],
    visibility = ["//visibility:public"],
)

bzl_library(
    name = "bzl",
    srcs = glob(["*.bzl"]),
    visibility = ["//visibility:public"],
    deps = [
        ":bazel_tools_rules",
        # "@bazel_tools//tools:bzl_srcs",
        # "@bazel_tools//tools/build_defs/repo/http.bzl:http_archive",
    ],
)

filegroup(
    name = "bzl_srcs",
    srcs = glob(["**"]),
    visibility = ["//csharp/private:__pkg__"],
)
