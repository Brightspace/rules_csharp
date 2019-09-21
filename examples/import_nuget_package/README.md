# `import_nuget_package` example

This example demonstrates using vendored NuGet packages. There are two ways to
do this: via a `.nupkg` file (which is a `.zip` file) or an extracted `.nupkg`
file.

The packages are defined in our [`WORKSPACE` file](../../WORKSPACE). This
folder contains the vendored packages and an example `csharp_library` that uses
them.
