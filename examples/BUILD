load("@d2l_rules_csharp//csharp:defs.bzl", "csharp_binary", "csharp_library")

csharp_binary(
    name = "hello",
    srcs = ["hello.cs"],
    deps = [":lib"],
)

csharp_library(
    name = "lib",
    srcs = ["lib.cs"],
    deps = ["@net472//:System.Linq"],
)
