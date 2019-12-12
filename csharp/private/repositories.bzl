"""
Rules to load all the .NET SDK & framework dependencies of rules_csharp.
"""
load(":sdk.bzl", "DOTNET_SDK")
load("//csharp/private/rules:create_net_workspace.bzl", "create_net_workspace")
load("//csharp/private/macros:nuget.bzl", "nuget_package")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# buildifier: disable=function-docstring
def csharp_repositories():
    _net_workspace()

    create_net_workspace()

    # NUnit
    nuget_package(
        name = "NUnitLite",
        package = "NUnitLite",
        version = "3.12.0",
        sha256 = "0b05b83f05b4eee07152e88b7b60b093fa408bfea56489a977ae655b640992f2",
    )

    nuget_package(
        name = "NUnit",
        package = "NUnit",
        version = "3.12.0",
        sha256 = "62b67516a08951a20b12b02e5d20b5045edbb687c3aabe9170286ec5bb9000a1",
    )

    # We need the .NET Core runtime, sdk and compiler for our current OS,
    # so that we can run the .NET core build of the compiler.

    _download_dotnet(
        os = "windows",
        url = DOTNET_SDK["windows"]["url"],
        hash = DOTNET_SDK["windows"]["hash"],
    )

    _download_dotnet(
        os = "linux",
        url = DOTNET_SDK["linux"]["url"],
        hash = DOTNET_SDK["linux"]["hash"],
    )

    _download_dotnet(
        os = "osx",
        url = DOTNET_SDK["osx"]["url"],
        hash = DOTNET_SDK["osx"]["hash"],
    )

def csharp_register_toolchains():
    native.register_toolchains(
        "@d2l_rules_csharp//csharp/private:csharp_windows_toolchain",
        "@d2l_rules_csharp//csharp/private:csharp_linux_toolchain",
        "@d2l_rules_csharp//csharp/private:csharp_osx_toolchain",
    )

def _download_dotnet(os, url, hash):
    http_archive(
        name = "netcore-sdk-%s" % os,
        urls = [url],
        sha256 = hash,
        build_file = "@d2l_rules_csharp//csharp/private:runtime.BUILD",
    )

def _net_framework_pkg(tfm, sha256):
    nuget_package(
        name = tfm,
        package = "Microsoft.NETFramework.ReferenceAssemblies.%s" % tfm,
        version = "1.0.0",
        sha256 = sha256,
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/%s.BUILD" % tfm,
    )

def _net_workspace():
    _net_framework_pkg("net20", "82450fb8a67696bdde41174918d385d50691f18945a246907cd96dfa3f670c82")
    _net_framework_pkg("net40", "4e97e946e032ab5538ff97d1a215c6814336b3ffda6806495e3f3150f3ca06ee")
    _net_framework_pkg("net45", "9b9e76d6497bfc6d0328528eb50f5fcc886a3eba4f47cdabd3df66f94174eac6")
    _net_framework_pkg("net451", "706278539689d45219715ff3fa19ff459127fc90104102eefcc236c1550f71e7")
    _net_framework_pkg("net452", "e8a90f1699d9b542e1bd6fdbc9f60f36acf420b95cace59e23d6be376dc61bb8")
    _net_framework_pkg("net46", "514e991aaacd84759f01b2933e6f4aa44a7d4caa39599f7d6c0a454b630286fa")
    _net_framework_pkg("net461", "a12eec50ccca0642e686082a6c8e9e06a6f538f022a47d130d36836818b17303")
    _net_framework_pkg("net462", "c4115c862f5ca778dc3fb649f455d38c095dfd10a1dc116b687944111462734d")
    _net_framework_pkg("net47", "261e3476e6be010a525064ce0901b8f77b09cdb7ea1fec88832a00ebe0356503")
    _net_framework_pkg("net471", "554c9305a9f064086861ae7db57b407147ec0850de2dfc5d86adabfa35b33180")
    _net_framework_pkg("net472", "2c8fd79ea19bd03cece40ed92b7bafde024f87c73abcebe3eff8da6e05b611af")
    _net_framework_pkg("net48", "fd0ba0a0c5ccce36e104abd055d2f4bf596ff3afc0dbc1f201d6cf9a50b783ce")

    # .NET Core
    nuget_package(
        name = "netcoreapp2.1",
        package = "Microsoft.NETCore.App",
        version = "2.1.13",
        sha256 = "8d4df9bf970096af0d73a0fd97384a98bce4bdb9006e8659b298c91f2fa2c47b",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/netcoreapp21.BUILD",
    )

    nuget_package(
        name = "netcoreapp2.2",
        package = "Microsoft.NETCore.App",
        version = "2.2.7",
        sha256 = "a4f166be783dedac38def8e9357ac74a4739119611635ac520b5fdd96645835e",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/netcoreapp22.BUILD",
    )

    nuget_package(
        name = "netcoreapp3.0",
        package = "Microsoft.NETCore.App.Ref",
        version = "3.0.0",
        sha256 = "3c7a2fbddfa63cdf47a02174ac51274b4d79a7b623efaf9ef5c7d253824023e2",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/netcoreapp30.BUILD",
    )

    # .NET Standard (& .NET Core)
    nuget_package(
        name = "NetStandard.Library",
        package = "NetStandard.Library",
        version = "2.0.3",
        sha256 = "3eb87644f79bcffb3c0331dbdac3c7837265f2cdf58a7bfd93e431776f77c9ba",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/netstandard20.BUILD",
    )

    nuget_package(
        name = "NetStandard.Library.Ref",
        package = "NetStandard.Library.Ref",
        version = "2.1.0",
        sha256 = "46ea2fcbd10a817685b85af7ce0c397d12944bdc81209e272de1e05efd33c78a",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/netstandard21.BUILD",
    )
