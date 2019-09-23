load(":rules/create_net_workspace.bzl", "create_net_workspace")
load(":macros/nuget.bzl", "nuget_package")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def csharp_repositories():
    nuget_package(
        name = "csharp-build-tools",
        package = "Microsoft.Net.Compilers.Toolset",
        version = "3.1.1",
        sha256 = "078e88a3f347e1428868cfd091634489f385379069e85a6707184ac07da9d481",
        build_file = "@d2l_rules_csharp//csharp/private:build-tools.BUILD",
    )

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
        name = "Microsoft.NETCore.App_2.1",
        package = "Microsoft.NETCore.App",
        version = "2.1.13",
        sha256 = "8d4df9bf970096af0d73a0fd97384a98bce4bdb9006e8659b298c91f2fa2c47b",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/netcoreapp21.BUILD",
    )

    nuget_package(
        name = "Microsoft.NETCore.App_2.2",
        package = "Microsoft.NETCore.App",
        version = "2.2.7",
        sha256 = "a4f166be783dedac38def8e9357ac74a4739119611635ac520b5fdd96645835e",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/netcoreapp22.BUILD",
    )

    nuget_package(
        name = "Microsoft.NETCore.App.Ref",
        package = "Microsoft.NETCore.App.Ref",
        version = "3.0.0",
        sha256 = "3c7a2fbddfa63cdf47a02174ac51274b4d79a7b623efaf9ef5c7d253824023e2",
        build_file = "@d2l_rules_csharp//csharp/private:frameworks/netcoreapp30.BUILD",
    )

    nuget_package(
        name = "Microsoft.NETCore.DotNetAppHost",
        package = "Microsoft.NETCore.DotNetAppHost",
        version = "2.2.6",
        sha256 = "a91c0aa20a2665f4475cc66b92b9a4f1a908d1f1d711f0163f4e9ca3366a97e8",
    )

    nuget_package(
        name = "Microsoft.NETCore.DotNetHostPolicy",
        package = "Microsoft.NETCore.DotNetHostPolicy",
        version = "2.2.6",
        sha256 = "2e0eb87a29502de80a3d06a74b475158d18d5f87e2e0bbe95b9e68feefbd820c",
    )

    nuget_package(
        name = "Microsoft.NETCore.DotNetHostResolver",
        package = "Microsoft.NETCore.DotNetHostResolver",
        version = "2.2.6",
        sha256 = "56d91d2046eb952c2704b459c8e89c0061dd41fcdb4ed00d1ad0d5552cbfdb64",
    )

    # .NET Standard (& .NET Core)
    nuget_package(
        name = "Microsoft.Win32.Primitives",
        package = "Microsoft.Win32.Primitives",
        version = "4.3.0",
        sha256 = "98134398f5cd4d6e785cb9cf014c0146f90839114ceff8f40f42364b240f0c48",
    )

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

    nuget_package(
        name = "System.AppContext",
        package = "System.AppContext",
        version = "4.3.0",
        sha256 = "ca0f792cd40ec05940d6d5b15dd42457226a4f8027a0373e0029ab36fcc68998",
    )

    nuget_package(
        name = "System.Buffers",
        package = "System.Buffers",
        version = "4.5.0",
        sha256 = "4c7c36ce7bbe2a26df2517c3edc1379d1607b26ec5ca7e698ce3995689c58efb",
    )

    nuget_package(
        name = "System.Collections",
        package = "System.Collections",
        version = "4.3.0",
        sha256 = "69f63b554b43eb0ff9998aab71ef2442bbc321f4b61970c834387bdc88f124a7",
    )

    nuget_package(
        name = "System.Collections.Concurrent",
        package = "System.Collections.Concurrent",
        version = "4.3.0",
        sha256 = "28c6390df2670de22c6b5dc3a6abf237c36445e644300167966360955a052172",
    )

    nuget_package(
        name = "System.Diagnostics.Contracts",
        package = "System.Diagnostics.Contracts",
        version = "4.3.0",
        sha256 = "2bbe28c949f456b8afde6c2b6d9c10150e8403433b1e6f5895c58b4632e3aabf",
    )

    nuget_package(
        name = "System.Diagnostics.Debug",
        package = "System.Diagnostics.Debug",
        version = "4.3.0",
        sha256 = "7e403bf528cf6d27a211cadb6d4b1bef4bbd07bc2a6ec74cf6cd4b9e82a3d203",
    )

    nuget_package(
        name = "System.Diagnostics.DiagnosticSource",
        package = "System.Diagnostics.DiagnosticSource",
        version = "4.5.1",
        sha256 = "81910346fd2fd0001ab90dfa0565e4264dc62d6d2c607e903f16b4a7697c0dc9",
    )

    nuget_package(
        name = "System.Diagnostics.Tools",
        package = "System.Diagnostics.Tools",
        version = "4.3.0",
        sha256 = "8153afd522ba0297b415084256534e77d72f40a06f331457f4ad093d58bcc346",
    )

    nuget_package(
        name = "System.Diagnostics.Tracing",
        package = "System.Diagnostics.Tracing",
        version = "4.3.0",
        sha256 = "8421136691c719584f62f6f80b47e1e33b3ef33bf818fa22c5a8242d98e96bd4",
    )

    nuget_package(
        name = "System.Globalization",
        package = "System.Globalization",
        version = "4.3.0",
        sha256 = "71a2f4a51985484b1aa1e65e58de414d0b46ac0b5a40fc058bc60e64f646e6b2",
    )

    nuget_package(
        name = "System.Globalization.Calendars",
        package = "System.Globalization.Calendars",
        version = "4.3.0",
        sha256 = "b8d383d043951609d2d9f30abcc884b48f5a3b0d34f8f7f2fc7faab9c01094f7",
    )

    nuget_package(
        name = "System.IO",
        package = "System.IO",
        version = "4.3.0",
        sha256 = "aeeca74077a414fe703eb0e257284d891217799fc8f4da632b9a54f873c38916",
    )

    nuget_package(
        name = "System.IO.Compression",
        package = "System.IO.Compression",
        version = "4.3.0",
        sha256 = "7f93eb4254208f95e3d999c7c575bc5e23a2bda06f7ea0daa3d49be805629f20",
    )

    nuget_package(
        name = "System.IO.Compression.ZipFile",
        package = "System.IO.Compression.ZipFile",
        version = "4.3.0",
        sha256 = "59097e2605acf8669131e89a8531546eb8655c81daa737294c55db46f02dbefb",
    )

    nuget_package(
        name = "System.IO.FileSystem",
        package = "System.IO.FileSystem",
        version = "4.3.0",
        sha256 = "bcd2189ef95acae563d167d17d82a90eb843a6d961a75a4df026269557764d7c",
    )

    nuget_package(
        name = "System.IO.FileSystem.Primitives",
        package = "System.IO.FileSystem.Primitives",
        version = "4.3.0",
        sha256 = "2cc9df83c5706afb3d70c9eaf67347f085ad02d49f934fc5cb8b3846df6bd648",
    )

    nuget_package(
        name = "System.Linq",
        package = "System.Linq",
        version = "4.3.0",
        sha256 = "479ba248bde5e9add7ad74922fa8f3faafcf732550cc4001ca2b9764d4aa0ff0",
    )

    nuget_package(
        name = "System.Linq.Expressions",
        package = "System.Linq.Expressions",
        version = "4.3.0",
        sha256 = "fb7a6f85963bae2a7c1c26df7542f38e50bd14f645a58a10c6191cb859b6c24f",
    )

    nuget_package(
        name = "System.Net.Http",
        package = "System.Net.Http",
        version = "4.3.4",
        sha256 = "14ca14d0aee794f2f1a038eed0d2f6d568e581af46a67028423b05845618b74d",
    )

    nuget_package(
        name = "System.Net.Primitives",
        package = "System.Net.Primitives",
        version = "4.3.1",
        sha256 = "a880858d0a3915c49f35279bf1738cc00e5a5203fe3ced227653b91d5a60bac3",
    )

    nuget_package(
        name = "System.Net.Sockets",
        package = "System.Net.Sockets",
        version = "4.3.0",
        sha256 = "8a5eddaf9553fd058383fd1cba1fb812cdaef0b63fffeaaa898f416666314aeb",
    )

    nuget_package(
        name = "System.ObjectModel",
        package = "System.ObjectModel",
        version = "4.3.0",
        sha256 = "82d9919163f62b0af79c7b43874c98b5c7b7f33d70ac6cdbe9f8e6e2ff3037a4",
    )

    nuget_package(
        name = "System.Reflection",
        package = "System.Reflection",
        version = "4.3.0",
        sha256 = "35049946964bbed3d60e5be6308746c5c56ec949f0f76654468d215ec12c8576",
    )

    nuget_package(
        name = "System.Reflection.Emit.ILGeneration",
        package = "System.Reflection.Emit.ILGeneration",
        version = "4.3.0",
        sha256 = "98a4649c41cd96ce20911c2b1208b7f41faf49a033fc6b772002ed4bdf313670",
    )

    nuget_package(
        name = "System.Reflection.Emit.Lightweight",
        package = "System.Reflection.Emit.Lightweight",
        version = "4.3.0",
        sha256 = "acac786bdc9929c6a39684991ebe02293549e958e1f799e2fb3b333f15a38762",
    )

    nuget_package(
        name = "System.Reflection.Extensions",
        package = "System.Reflection.Extensions",
        version = "4.3.0",
        sha256 = "98c38263351e9e3778ad621fabbcc85fd3c5624fdd694c85d00f25d616f27409",
    )

    nuget_package(
        name = "System.Reflection.Primitives",
        package = "System.Reflection.Primitives",
        version = "4.3.0",
        sha256 = "e68830581e2f9504e5de38e4d718e7886da8cdb1488d94cbf6e834bac650b813",
    )

    nuget_package(
        name = "System.Reflection.TypeExtensions",
        package = "System.Reflection.TypeExtensions",
        version = "4.5.1",
        sha256 = "fcfa2d31ff5951b5452fcdff25c1892d9e8e8431657e091b231bd5f90ef4830d",
    )

    nuget_package(
        name = "System.Resources.ResourceManager",
        package = "System.Resources.ResourceManager",
        version = "4.3.0",
        sha256 = "89d88e0fddf16dbadbc304a70f898e440f51622fc3fd4e3c79152c9ff5a7586a",
    )

    nuget_package(
        name = "System.Runtime",
        package = "System.Runtime",
        version = "4.3.1",
        sha256 = "47d4faf00cd2d4f249eefe80473f6fa3cf2928bd5d5aa2ce00d838a64423900d",
    )

    nuget_package(
        name = "System.Runtime.CompilerServices.Unsafe",
        package = "System.Runtime.CompilerServices.Unsafe",
        version = "4.5.2",
        sha256 = "f1e5175c658ed8b2fbb804cc6727b6882a503844e7da309c8d4846e9ca11e4ef",
    )

    nuget_package(
        name = "System.Runtime.Extensions",
        package = "System.Runtime.Extensions",
        version = "4.3.1",
        sha256 = "c6597f005eac175b28435e69ac03c8547487ebd0a22f813d3875431f2ae6f3af",
    )

    nuget_package(
        name = "System.Runtime.Handles",
        package = "System.Runtime.Handles",
        version = "4.3.0",
        sha256 = "289e5a5e81a9079e98ebe89ea4191da71fc07da243022b71e2fae42ea47b826b",
    )

    nuget_package(
        name = "System.Runtime.InteropServices",
        package = "System.Runtime.InteropServices",
        version = "4.3.0",
        sha256 = "f2c0c7f965097c247eedee277e97ed8fffa5b2d122662c56501b9e476ce61e02",
    )

    nuget_package(
        name = "System.Runtime.InteropServices.RuntimeInformation",
        package = "System.Runtime.InteropServices.RuntimeInformation",
        version = "4.3.0",
        sha256 = "318a65ebf6720ba8639b359121efa20e895d38c5b599f6f05ec76e0275c82860",
    )

    nuget_package(
        name = "System.Runtime.Numerics",
        package = "System.Runtime.Numerics",
        version = "4.3.0",
        sha256 = "3f98c70a031b80531888e36fce668a15e3aa7002033eefd4f1b395acd3d82aa7",
    )

    nuget_package(
        name = "System.Runtime.WindowsRuntime",
        package = "System.Runtime.WindowsRuntime",
        version = "4.3.0",
        sha256 = "b45f553582e4b7f774c8f543252d1f7698f4829210ce8d578138dcaab810eb14",
    )

    nuget_package(
        name = "System.Security.Cryptography.Algorithms",
        package = "System.Security.Cryptography.Algorithms",
        version = "4.3.1",
        sha256 = "4253bfa69464fcec836070a2983f3aed102528839a922743d0808d3adeb75cd4",
    )

    nuget_package(
        name = "System.Security.Cryptography.Cng",
        package = "System.Security.Cryptography.Cng",
        version = "4.5.0",
        sha256 = "f659516c4718d5f1d8b939f7bc665a0b1b05c5202a5e5e1b0c0e91cfd6f4a4de",
    )

    nuget_package(
        name = "System.Security.Cryptography.Csp",
        package = "System.Security.Cryptography.Csp",
        version = "4.3.0",
        sha256 = "a1e7dd4d4fd9d8f594f6795ab7cba24431aafcf199a123d182430bd75a66bcf4",
    )

    nuget_package(
        name = "System.Security.Cryptography.Encoding",
        package = "System.Security.Cryptography.Encoding",
        version = "4.3.0",
        sha256 = "62e81ef3d37a33e35c6e572f5cc7b21d9ea46437f006fdcb3cc0e217c1e126cb",
    )

    nuget_package(
        name = "System.Security.Cryptography.OpenSsl",
        package = "System.Security.Cryptography.OpenSsl",
        version = "4.5.1",
        sha256 = "13f553e5815246d2b0d715944a8af9577784f8176ac6c5525e43b9eb48bf29fe",
    )

    nuget_package(
        name = "System.Security.Cryptography.Primitives",
        package = "System.Security.Cryptography.Primitives",
        version = "4.3.0",
        sha256 = "7e7162ec1dd29d58f96be05b8179db8e718dbd6ac2114e87a7fc23b235b3df5f",
    )

    nuget_package(
        name = "System.Security.Cryptography.X509Certificates",
        package = "System.Security.Cryptography.X509Certificates",
        version = "4.3.2",
        sha256 = "b24680b48aa291b06fd79f3a1287128b083e42a06cf6de6329402bfd06fdca2d",
    )

    nuget_package(
        name = "System.Text.Encoding",
        package = "System.Text.Encoding",
        version = "4.3.0",
        sha256 = "19cb475462d901afebaa404d86c0469ec89674acafe950ee6d8a4692e3a404b8",
    )

    nuget_package(
        name = "System.Text.Encoding.Extensions",
        package = "System.Text.Encoding.Extensions",
        version = "4.3.0",
        sha256 = "bee7c75e0f1000ac4796e8cf1c772bb46c00a859ac083e872a37c30221f20187",
    )

    nuget_package(
        name = "System.Text.RegularExpressions",
        package = "System.Text.RegularExpressions",
        version = "4.3.1",
        sha256 = "0f1b046749e73e8cf20b55b5eb8cab3145f09c07474a14bd127ec8983fc624c3",
    )

    nuget_package(
        name = "System.Threading",
        package = "System.Threading",
        version = "4.3.0",
        sha256 = "643437751e29cd5c266aa060e2169c65a55e9d0ff7c8017fb95ec15d95e38967",
    )

    nuget_package(
        name = "System.Threading.Tasks",
        package = "System.Threading.Tasks",
        version = "4.3.0",
        sha256 = "679ad77c9d445e9dc6df620a646899ea4a0c8d1bb49fc0b5346af0a5d21e9f8c",
    )

    nuget_package(
        name = "System.Threading.Tasks.Extensions",
        package = "System.Threading.Tasks.Extensions",
        version = "4.5.3",
        sha256 = "f138256c2e8a0479437927e0afa7797469fbc2ef2d7785c4465d89532a34f93c",
    )

    nuget_package(
        name = "System.Threading.Timer",
        package = "System.Threading.Timer",
        version = "4.3.0",
        sha256 = "a6686c96685084fdf64d66c1ce82132d9e01a0e441a98936e4e59baeed38a7db",
    )

    nuget_package(
        name = "System.Xml.ReaderWriter",
        package = "System.Xml.ReaderWriter",
        version = "4.3.1",
        sha256 = "7e32092b98e9cfdf6038dd933694eada3c37595b680852cef6b52f904fdbc995",
    )

    nuget_package(
        name = "System.Xml.XDocument",
        package = "System.Xml.XDocument",
        version = "4.3.0",
        sha256 = "ad6b5d72672e12534e4b309e85f9722b01e40d1a623a1249b3c09e4349750822",
    )
