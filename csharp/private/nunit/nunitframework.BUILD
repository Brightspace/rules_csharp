load("@d2l_rules_csharp//csharp:defs.bzl", "import_library", "import_multiframework_library")

# TODO: just use the default BUILD file for nuget_package (it's not in this
# repo yet, need to fix a bug).

import_library(
    name = "nunit.framework-net40",
    target_framework = "net40",
    dll = "lib/net40/nunit.framework.dll",
    pdb = "lib/net40/nunit.framework.pdb",
)

import_library(
    name = "nunit.framework-net45",
    target_framework = "net45",
    dll = "lib/net45/nunit.framework.dll",
    pdb = "lib/net45/nunit.framework.pdb",
)

import_library(
    name = "nunit.framework-netstandard1.4",
    target_framework = "netstandard1.4",
    dll = "lib/netstandard1.4/nunit.framework.dll",
    pdb = "lib/netstandard1.4/nunit.framework.pdb",
)

import_library(
    name = "nunit.framework-netstandard2.0",
    target_framework = "netstandard2.0",
    dll = "lib/netstandard2.0/nunit.framework.dll",
    pdb = "lib/netstandard2.0/nunit.framework.pdb",
)

import_multiframework_library(
    name = "nunit.framework",
    net40 = "nunit.framework-net40",
    net45 = "nunit.framework-net45",
    netstandard1_4 = "nunit.framework-netstandard1.4",
    netstandard2_0 = "nunit.framework-netstandard2.0",
    visibility = ["//visibility:public"],
)
