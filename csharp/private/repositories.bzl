load(":sdk.bzl", "DOTNET_SDK")
load(":rules/create_net_workspace.bzl", "create_net_workspace")
load(":macros/nuget.bzl", "nuget_package")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

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

def _net_workspace():
    nuget_package(
        name = "net20",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net20",
        version = "1.0.0-preview.2",
        sha256 = "caaa20a20da4e5e3b408b5479fae15e81effb5601b303efc9d171fbb0f49ac18",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net20.BUILD",
    )

    nuget_package(
        name = "net40",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net40",
        version = "1.0.0-preview.2",
        sha256 = "65347e2f553081424aee2ed3507224d92bfee2b7d2e2bed66484bdc948d4637a",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net40.BUILD",
    )

    nuget_package(
        name = "net45",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net45",
        version = "1.0.0-preview.2",
        sha256 = "a39af6dc89f75a153661c9c98290da0a810ce431e0e3e10fa7d137eb73c0b837",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net45.BUILD",
    )

    nuget_package(
        name = "net451",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net451",
        version = "1.0.0-preview.2",
        sha256 = "dbb2cb1698d54f7b65b40cc8bb930915eb194bc967ea07521e47331c2277894f",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net451.BUILD",
    )

    nuget_package(
        name = "net452",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net452",
        version = "1.0.0-preview.2",
        sha256 = "fbf74fe47de381632ef1564d1599b503ece6e56674c43f5ac36846710bc05888",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net452.BUILD",
    )

    nuget_package(
        name = "net46",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net46",
        version = "1.0.0-preview.2",
        sha256 = "118fcb427ac365ad74d80a2906d412842548f58cf933ffcdf81c8ecf41225cd3",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net46.BUILD",
    )

    nuget_package(
        name = "net461",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net461",
        version = "1.0.0-preview.2",
        sha256 = "5ac0c8b6e26e6cb525a09cda5a47df971ca126e4c953d993c688b7a74ce40724",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net461.BUILD",
    )

    nuget_package(
        name = "net462",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net462",
        version = "1.0.0-preview.2",
        sha256 = "22fdc05543faa9ab7a638d9a238a6e6b4280bfac5348b96345062e10dc6c9b36",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net462.BUILD",
    )

    nuget_package(
        name = "net47",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net47",
        version = "1.0.0-preview.2",
        sha256 = "164d7cbcc3c020b06a0b28ebe60a3c291ce2c568e816ca6d8a0a7911694f6015",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net47.BUILD",
    )

    nuget_package(
        name = "net471",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net471",
        version = "1.0.0-preview.2",
        sha256 = "8d90b26b1bb7247ef8e52d46523532428b1043a53de5d5db08ed7f94b1a879f8",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net471.BUILD",
    )

    nuget_package(
        name = "net472",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net472",
        version = "1.0.0-preview.2",
        sha256 = "ebca4bd6142f768e9ab96115a820fa2f5705cb07355e67f67613f58b0c0e3e97",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net472.BUILD",
    )

    nuget_package(
        name = "net48",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net48",
        version = "1.0.0-preview.2",
        sha256 = "912f6eed993e77c83cb8b92db72d50df7d06e4c4a02486474eae460728291989",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/net48.BUILD",
    )

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
