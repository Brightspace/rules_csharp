load("@d2l_rules_csharp//csharp:defs.bzl", "csharp_binary", "csharp_library", "import_multiframework_library", "csharp_nunit_test")

# bazel run //examples:hello
csharp_binary(
    name = "hello",
    srcs = ["hello.cs"],
    deps = [":lib"],
)

# bazel test //examples:lib_test
csharp_nunit_test(
    name = "lib_test",
    srcs = ["libtest.cs"],
    deps = [":lib"],
)

csharp_library(
    name = "lib",
    srcs = ["lib.cs"],
    deps = ["@net472//:System.Linq"],
)
