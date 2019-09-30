load(
    "@d2l_rules_csharp//csharp:defs.bzl",
    "csharp_binary",
    "csharp_library",
    "csharp_nunit_test",
)

csharp_binary(
    name = "strong_binary_consumer",
    srcs = ["min_main.cs"],
    keyfile = "example.snk",
    target_frameworks = ["net472"],
    deps = [":strong_lib"],
)

csharp_binary(
    name = "binary_consumer",
    srcs = ["min_main.cs"],
    target_frameworks = ["net472"],
    deps = [":strong_lib"],
)

csharp_nunit_test(
    name = "strong_test_consumer",
    keyfile = "example.snk",
    target_frameworks = ["net472"],
    deps = [":strong_lib"],
)

csharp_nunit_test(
    name = "test_consumer",
    target_frameworks = ["net472"],
    deps = [":strong_lib"],
)

csharp_library(
    name = "strong_library_consumer",
    keyfile = "example.snk",
    target_frameworks = ["net472"],
    deps = [":strong_lib"],
)

csharp_library(
    name = "library_consumer",
    target_frameworks = ["net472"],
    deps = [":strong_lib"],
)

csharp_library(
    name = "strong_lib",
    keyfile = "example.snk",
    target_frameworks = ["net472"],
)
