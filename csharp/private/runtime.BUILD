load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@d2l_rules_csharp//csharp:defs.bzl", "dotnet_wrapper")

_WRAPPER_TEMPLATE = "@d2l_rules_csharp//csharp/private:rules/main.cc"

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
        "sdk/3.0.100/Roslyn/bincore/**/*",
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
    ),
    visibility = ["//visibility:public"],
    deps = ["@bazel_tools//tools/cpp/runfiles"],
)

dotnet_wrapper(
    name = "main-cc",
    src = _WRAPPER_TEMPLATE,
    target = glob(
        [
            "dotnet",
            "dotnet.exe",
        ],
    ),
)
