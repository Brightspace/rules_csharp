exports_files(
    ["defs.for_docs.bzl"],
    visibility = ["//docs:__pkg__"],
)

filegroup(
    name = "bzl_srcs",
    srcs = glob(["*.bzl"]) + [
        "//csharp/privates:bzl_srcs",
    ],
    visibility = ["//docs:__pkg__"],
)
