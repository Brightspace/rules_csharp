load("@d2l_rules_csharp//csharp:defs.bzl", "import_library", "import_multiframework_library")

# TODO: just use the default BUILD file for nuget_package (it's not in this
# repo yet, need to fix a bug).

import_library(
    name = "nunitlite-net40",
    target_framework = "net40",
    dll = "lib/net40/nunitlite.dll",
    pdb = "lib/net40/nunitlite.pdb",
)

import_library(
    name = "nunitlite-net45",
    target_framework = "net45",
    dll = "lib/net45/nunitlite.dll",
    pdb = "lib/net45/nunitlite.pdb",
)

import_library(
    name = "nunitlite-netstandard1.4",
    target_framework = "netstandard1.4",
    dll = "lib/netstandard1.4/nunitlite.dll",
    pdb = "lib/netstandard1.4/nunitlite.pdb",
)

import_library(
    name = "nunitlite-netstandard2.0",
    target_framework = "netstandard2.0",
    dll = "lib/netstandard2.0/nunitlite.dll",
    pdb = "lib/netstandard2.0/nunitlite.pdb",
)

import_multiframework_library(
    name = "nunitlite",
    net40 = "nunitlite-net40",
    net45 = "nunitlite-net45",
    netstandard1_4 = "nunitlite-netstandard1.4",
    netstandard2_0 = "nunitlite-netstandard2.0",
    visibility = ["//visibility:public"],
)
