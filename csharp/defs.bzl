load(
    "//csharp/private:repositories.bzl",
    _csharp_register_toolchains = "csharp_register_toolchains",
    _csharp_repositories = "csharp_repositories",
)
load(
    "//csharp/private:rules/binary.bzl",
    _csharp_binary = "csharp_binary",
)
load(
    "//csharp/private:rules/library.bzl",
    _csharp_library = "csharp_library",
)
load(
    "//csharp/private:rules/imports.bzl",
    _import_library = "import_library",
)
load(
    "//csharp/private:rules/nuget.bzl",
    _nuget_package = "nuget_package",
)
#load(
#    "//csharp/private:rules/test.bzl",
#    _csharp_nunit_test = "csharp_nunit_test",
#)

csharp_binary = _csharp_binary
csharp_library = _csharp_library

#csharp_nunit_test = _csharp_nunit_test
csharp_register_toolchains = _csharp_register_toolchains
csharp_repositories = _csharp_repositories
import_library = _import_library
nuget_package = _nuget_package
