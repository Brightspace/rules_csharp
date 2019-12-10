load(
    "//csharp/private:repositories.bzl",
    _csharp_register_toolchains = "csharp_register_toolchains",
    _csharp_repositories = "csharp_repositories",
)
load(
    "//csharp/private:rules/wrapper.bzl",
    _dotnet_wrapper = "dotnet_wrapper",
)
load(
    "//csharp/private:macros/nuget.bzl",
    _import_nuget_package = "import_nuget_package",
    _nuget_package = "nuget_package",
)

dotnet_wrapper = _dotnet_wrapper
csharp_register_toolchains = _csharp_register_toolchains
csharp_repositories = _csharp_repositories
import_nuget_package = _import_nuget_package
nuget_package = _nuget_package
