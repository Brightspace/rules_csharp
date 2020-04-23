"""
Rules for compiling NUnit tests.
"""

load("//csharp/private:rules/binary_private.bzl", "csharp_binary_private")

def csharp_nunit_test(**kwargs):
    deps = kwargs.pop("deps", []) + [
        "@NUnitLite//:nunitlite",
        "@NUnit//:nunit.framework",
    ]

    srcs = kwargs.pop("srcs", []) + [
        "@d2l_rules_csharp//csharp/private:nunit/shim.cs",
    ]

    csharp_binary_private(
        srcs = srcs,
        deps = deps,
        winexe = False,  # winexe doesn't make sense for tests
        **kwargs
    )
