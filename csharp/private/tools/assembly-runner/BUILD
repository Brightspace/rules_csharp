load(":lib.bzl", "wrap_csharp_exe")
load("//csharp:defs.bzl", "csharp_binary")


exports_files([
    "bazel.runtimeconfig.json",
])

# so csharp_binary(name = "eh", ...) would be a macro that calls these two rules:
csharp_binary(
    name = "eh-unwrapped",
    srcs = ["eh.cs"],
    target_frameworks = ["netcoreapp3.0"],
)

# This augments the providers from eh-unwrapped to include a DefaultInfo which
# has the bespoke wrapper exe for eh.
wrap_csharp_exe(
    name = "eh",

    # By convention this would be the first element from target_frameworks in
    # the macro arg.
    target_framework = "netcoreapp3.0"
)
