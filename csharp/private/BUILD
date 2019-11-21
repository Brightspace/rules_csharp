load(":toolchains.bzl", "configure_toolchain")

exports_files(["nunit/shim.cs", "rules/ResGen.csproj", "rules/main.cc"])

toolchain_type(name = "toolchain_type")

configure_toolchain("windows")

configure_toolchain("linux")

configure_toolchain("osx")
