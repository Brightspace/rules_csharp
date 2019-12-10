load(":toolchains.bzl", "configure_toolchain")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

bzl_library(
    name = "bzl",
    srcs = glob(["*.bzl"]),
    visibility = ["//visibility:public"],
    deps = [
        "//csharp/private/actions:bzl",
        "//csharp/private/macros:bzl",
        "//csharp/private/rules:bzl",
    ],
)

exports_files([
    "nunit/shim.cs",
    "wrappers/dotnet.cc",
])

toolchain_type(name = "toolchain_type")

configure_toolchain("windows")

configure_toolchain("linux")

configure_toolchain("osx")
