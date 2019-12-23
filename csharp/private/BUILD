load(":toolchains.bzl", "configure_toolchain")

filegroup(
    name = "bzl_srcs",
    srcs = glob(["**/*.bzl"]),
    visibility = ["//docs:__pkg__"],
)

exports_files([
    "nunit/shim.cs",
    "wrappers/dotnet.cc",
    "runtimeconfig.json.tpl",
])

toolchain_type(name = "toolchain_type")

configure_toolchain(os = "windows")

configure_toolchain(os = "linux")

configure_toolchain(os = "osx")
