load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

bzl_library(
    name = "bzl",
    srcs = glob(["*.bzl"]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "bzl_srcs",
    srcs = glob(["**"]),
    visibility = ["//csharp/private:__pkg__"],
)
