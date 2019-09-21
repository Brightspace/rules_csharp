# Using NuGet Packages

There are three options for using NuGet packages:

1. Use `nuget_package` download a package from the internet.
2. Use `import_nuget_package` to point at a directory containing the contents
   of a package.
3. Use `import_nuget_package` to point at a `.nupkg` file.

(TODO: link to the API reference docs when we have them)

When you use any of these options and don't provide either `build_file` or
`build_file_content`, a default `BUILD` file will be used that calls the
`setup_basic_nuget_package` macro.

This macro uses `import_library` to import every DLL and
`import_multiframework_library` to stitch them together into one target (see
[docs/MultiTargetingDesign.md](docs/MultiTargetingDesign.md) for more info).

The downside to this is that it always leaves `deps` empty for these targets,
because of limitations with how Bazel works. Your options are:

1. Create a better `BUILD` file from scratch (we should provide a tool to do
   this) and use `build_file`/`build_file_content`.
2. Always add the transitive references of your packages to your `deps` when
   you reference the package.


