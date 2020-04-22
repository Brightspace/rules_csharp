load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@d2l_rules_csharp//csharp:defs.bzl", "dotnet_wrapper")

exports_files(
    glob(
        [
            "dotnet",
            "dotnet.exe",  # windows, yeesh
        ],
        allow_empty = True,
    ) + glob([
        "host/**/*",
        "shared/**/*",
    ]) +
    # csharp compiler: csc
    glob([
        "sdk/**/Roslyn/bincore/**/*",
    ]),
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "dotnetw",
    srcs = [":main-cc"],
    data = glob(
        [
            "dotnet",
            "dotnet.exe",
        ],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
    deps = ["@bazel_tools//tools/cpp/runfiles"],
)

dotnet_wrapper(
    name = "main-cc",
    dotnet = glob(
        [
            "dotnet",
            "dotnet.exe",
        ],
        allow_empty = True,
    ),
)
