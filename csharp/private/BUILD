load(":toolchains.bzl", "configure_toolchain")

filegroup(
    name = "bzl_srcs",
    srcs = glob(["*.bzl"]) + [
        "//csharp/private/actions:bzl_srcs",
        "//csharp/private/macros:bzl_srcs",
        "//csharp/private/rules:bzl_srcs",
    ],
    visibility = ["//csharp:__pkg__"],
)

exports_files([
    "nunit/shim.cs",
    "wrappers/dotnet.cc",
])

toolchain_type(name = "toolchain_type")

configure_toolchain("windows")

configure_toolchain("linux")

configure_toolchain("osx")
