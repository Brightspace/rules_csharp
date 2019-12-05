load(":toolchains.bzl", "configure_toolchain")

exports_files([
    "nunit/shim.cs",
    "wrappers/dotnet.cc",
    "wrappers/resx.bash",
    "wrappers/ResGen.csproj",
])

toolchain_type(name = "toolchain_type")

configure_toolchain("windows")

configure_toolchain("linux")

configure_toolchain("osx")
