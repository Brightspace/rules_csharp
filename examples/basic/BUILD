load(
    "@d2l_rules_csharp//csharp:defs.bzl",
    "csharp_binary",
    "csharp_library",
    "csharp_nunit_test",
    "dotnet_wrapper"
)

# bazel run //examples:hello
csharp_binary(
    name = "hello",
    srcs = ["hello.cs"],
    target_frameworks = ["netcoreapp3.0"],
    deps = [":lib"],
)

dotnet_wrapper(
    name = "hello-wrapper.cc",
    args = ["basic/bazelout/netcoreapp3.0/hello.exe"],
    dotnet = ["@netcore-sdk-osx//:dotnet"],
)

cc_binary(
    name = "hello.exe",
    srcs = [":hello-wrapper.cc"],
    data = [
      ":hello",
      "@netcore-sdk-osx//:dotnet",
    ],
    deps = ["@bazel_tools//tools/cpp/runfiles"],
)

# bazel test //examples:lib_test
# NOTE: this doesn't work yet because we aren't setting up the runfiles
# correctly. If you copy out all the dlls/exes to a common folder it does
# though.
csharp_nunit_test(
    name = "lib_test",
    srcs = ["libtest.cs"],
    target_frameworks = ["netcoreapp3.0"],
    deps = [":lib"],
)

csharp_library(
    name = "lib",
    srcs = ["lib.cs"],
    target_frameworks = ["netcoreapp3.0"],
)
