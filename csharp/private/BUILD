load(":toolchains.bzl", "configure_toolchain")

exports_files(["nunit/shim.cs", "rules/ResGen.csproj"])

toolchain_type(name = "toolchain_type")

configure_toolchain(
    "windows",
    exe = "dotnet.exe",
)

configure_toolchain("linux")

configure_toolchain("osx")
