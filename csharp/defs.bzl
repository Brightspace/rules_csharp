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
    "//csharp/private:rules/resgen.bzl",
    _csharp_resx = "csharp_resx",
)
load(
    "//csharp/private:rules/library.bzl",
    _csharp_library = "csharp_library",
)
load(
    "//csharp/private:rules/nunit_test.bzl",
    _csharp_nunit_test = "csharp_nunit_test",
)
load(
    "//csharp/private:rules/imports.bzl",
    _import_library = "import_library",
    _import_multiframework_library = "import_multiframework_library",
)
load(
    "//csharp/private:macros/nuget.bzl",
    _import_nuget_package = "import_nuget_package",
    _nuget_package = "nuget_package",
)
load(
    "//csharp/private:macros/setup_basic_nuget_package.bzl",
    _setup_basic_nuget_package = "setup_basic_nuget_package",
)

csharp_binary = _csharp_binary
csharp_library = _csharp_library
csharp_resx = _csharp_resx
csharp_nunit_test = _csharp_nunit_test
csharp_register_toolchains = _csharp_register_toolchains
csharp_repositories = _csharp_repositories
import_multiframework_library = _import_multiframework_library
import_library = _import_library
import_nuget_package = _import_nuget_package
nuget_package = _nuget_package
setup_basic_nuget_package = _setup_basic_nuget_package
