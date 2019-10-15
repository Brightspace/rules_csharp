load(
    "@d2l_rules_csharp//csharp:defs.bzl",
    "csharp_binary",
    "csharp_resx"
)

# bazel run //examples:hello
csharp_binary(
    name = "hello",
    srcs = ["hello.cs", "Strings.Designer.cs"],
    resources = [":hello.resources"],
    target_frameworks = ["net472"],
    deps = ["@net//:System.Linq"],
)

csharp_resx(
    name = "hello.resources",
    src = "Strings.resx",
    identifier = "Hello.Strings.resource",
    target_frameworks = ["net472"],
)