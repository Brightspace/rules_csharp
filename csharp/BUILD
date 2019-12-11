load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

bzl_library(
    name = "bzl",
    srcs = [
        "defs.for_docs.bzl",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//csharp/private:bzl",
    ],
)

filegroup(
    name = "bzl_srcs",
    srcs = glob(["*.bzl"]) + [
        "//csharp/private:bzl_srcs",
    ],
    visibility = ["//visibility:public"],
    # visibility = [
    #     "//csharp:__pkg__",
    #     "//docs:__pkg__",
    # ],
)
