load(":rules/nuget.bzl", "nuget_package")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def csharp_repositories():
    nuget_package(
        name = "csharp-build-tools",
        package = "Microsoft.Net.Compilers.Toolset",
        version = "3.1.1",
        sha256 = "078e88a3f347e1428868cfd091634489f385379069e85a6707184ac07da9d481",
        build_file = "@d2l_rules_csharp//csharp/private:build-tools.BUILD",
    )

    # TODO: create @net namespace to aggregate @net472 etc. with
    # import_multiframework_library rules.

    nuget_package(
        name = "net20",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net20",
        version = "1.0.0-preview.2",
        sha256 = "caaa20a20da4e5e3b408b5479fae15e81effb5601b303efc9d171fbb0f49ac18",
    )

    nuget_package(
        name = "net40",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net40",
        version = "1.0.0-preview.2",
        sha256 = "65347e2f553081424aee2ed3507224d92bfee2b7d2e2bed66484bdc948d4637a",
    )

    nuget_package(
        name = "net45",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net45",
        version = "1.0.0-preview.2",
        sha256 = "a39af6dc89f75a153661c9c98290da0a810ce431e0e3e10fa7d137eb73c0b837",
    )

    nuget_package(
        name = "net451",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net451",
        version = "1.0.0-preview.2",
        sha256 = "dbb2cb1698d54f7b65b40cc8bb930915eb194bc967ea07521e47331c2277894f",
    )

    nuget_package(
        name = "net452",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net452",
        version = "1.0.0-preview.2",
        sha256 = "fbf74fe47de381632ef1564d1599b503ece6e56674c43f5ac36846710bc05888",
    )

    nuget_package(
        name = "net46",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net46",
        version = "1.0.0-preview.2",
        sha256 = "118fcb427ac365ad74d80a2906d412842548f58cf933ffcdf81c8ecf41225cd3",
    )

    nuget_package(
        name = "net461",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net461",
        version = "1.0.0-preview.2",
        sha256 = "5ac0c8b6e26e6cb525a09cda5a47df971ca126e4c953d993c688b7a74ce40724",
    )

    nuget_package(
        name = "net462",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net462",
        version = "1.0.0-preview.2",
        sha256 = "22fdc05543faa9ab7a638d9a238a6e6b4280bfac5348b96345062e10dc6c9b36",
    )

    nuget_package(
        name = "net47",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net47",
        version = "1.0.0-preview.2",
        sha256 = "164d7cbcc3c020b06a0b28ebe60a3c291ce2c568e816ca6d8a0a7911694f6015",
    )

    nuget_package(
        name = "net471",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net471",
        version = "1.0.0-preview.2",
        sha256 = "8d90b26b1bb7247ef8e52d46523532428b1043a53de5d5db08ed7f94b1a879f8",
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
    )

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

    # We need the .NET Core runtime for whatever OS where executing our build
    # on so that we can run the .NET core build of the compiler (from
    # @csharp-build-tools).

    _download_runtime(
        os = "windows",
        url = "https://download.visualstudio.microsoft.com/download/pr/4fc551ff-0fbc-45ae-b35f-a8666ff1986f/0a6f2d0cf10379b47f6d55be5c31b95b/dotnet-runtime-3.0.0-preview3-27503-5-win-x64.zip",
        hash = "e648aafbfdbbdc6bac14c052a9e05f43aa916412971e0ccace0b958279c488e0",
    )

    _download_runtime(
        os = "linux",
        url = "https://download.visualstudio.microsoft.com/download/pr/01cf5a3b-24a5-4de1-8a25-9b57583bd737/f27582e4520e14b7e9ab3f7f239e1e3c/dotnet-runtime-3.0.0-preview3-27503-5-linux-x64.tar.gz",
        hash = "0435409448dd6c07ea4eef1921c480c8b68044c8601d5d9f549f54d16083433f",
    )

    _download_runtime(
        os = "osx",
        url = "https://download.visualstudio.microsoft.com/download/pr/4af9752c-5280-4594-a64d-f352ca5eb6bf/144f1f651ea56bd42eb124e9193531ad/dotnet-runtime-3.0.0-preview3-27503-5-osx-x64.tar.gz",
        hash = "2a1615aaf64bc8d8f26c15f81b9e1457770d910ea6ebe7458f309326de863552",
    )

def csharp_register_toolchains():
    native.register_toolchains(
        "@d2l_rules_csharp//csharp/private:csharp_windows_toolchain",
        "@d2l_rules_csharp//csharp/private:csharp_linux_toolchain",
        "@d2l_rules_csharp//csharp/private:csharp_osx_toolchain",
    )

def _download_runtime(os, url, hash):
    http_archive(
        name = "netcore-runtime-%s" % os,
        urls = [url],
        sha256 = hash,
        build_file = "@d2l_rules_csharp//csharp/private:runtime.BUILD",
    )
