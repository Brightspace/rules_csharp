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

    # TODO: rename this to net472 and make @net// targets the union of targets
    # from different frameworks.
    nuget_package(
        name = "net",
        package = "Microsoft.NETFramework.ReferenceAssemblies.net472",
        version = "1.0.0-preview.2",
        sha256 = "ebca4bd6142f768e9ab96115a820fa2f5705cb07355e67f67613f58b0c0e3e97",
        build_file = "@d2l_rules_csharp//csharp/private:netframework.BUILD",
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
