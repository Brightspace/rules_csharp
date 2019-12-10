<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#dotnet_wrapper"></a>

## dotnet_wrapper

<pre>
dotnet_wrapper(<a href="#dotnet_wrapper-name">name</a>, <a href="#dotnet_wrapper-src">src</a>, <a href="#dotnet_wrapper-template">template</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| src |  The name of the dotnet executable. On windows this should be 'dotnet.exe', and 'dotnet' on linux/macOS.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |
| template |  Path to the program that will wrap the dotnet executable. This program will be compiled and used instead of directly calling the dotnet executable.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | @d2l_rules_csharp//csharp/private:wrappers/dotnet.cc |


<a name="#csharp_register_toolchains"></a>

## csharp_register_toolchains

<pre>
csharp_register_toolchains()
</pre>



**PARAMETERS**



<a name="#csharp_repositories"></a>

## csharp_repositories

<pre>
csharp_repositories()
</pre>



**PARAMETERS**



<a name="#import_nuget_package"></a>

## import_nuget_package

<pre>
import_nuget_package(<a href="#import_nuget_package-name">name</a>, <a href="#import_nuget_package-dir">dir</a>, <a href="#import_nuget_package-file">file</a>, <a href="#import_nuget_package-build_file">build_file</a>, <a href="#import_nuget_package-build_file_content">build_file_content</a>, <a href="#import_nuget_package-sha256">sha256</a>)
</pre>

Import a vendored NuGet package from either a directory or .nupkg file.

Rather than downloading the package over HTTP from a package source, an
extracted package directory or a .nupkg file can be used. These may be
checked into your repository within your workspace, or somewhere else on
your disk.

Exactly one of either the dir or file arguments must be provided. They can
either be a relative path in the workspace, or an absolute path. Note that
paths on Windows use forward slashes.

At most one of build_file or build_file_content may be provided. If neither
are, a default BUILD file will be used that makes a "best effort" to wire
up the package. See docs/UsingNuGetPacakges.md for more info.


**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  A unique name for the package's workspace.   |  none |
| dir |  A directory containing an extracted package.   |  <code>None</code> |
| file |  A path to a nupkg file   |  <code>None</code> |
| build_file |  The path to a BUILD file to use for the package.   |  <code>None</code> |
| build_file_content |  A string containing the contents of a BUILD file.   |  <code>None</code> |
| sha256 |  The SHA256 of the package.<br><br>  This is only used when importing nupkg files. You may or may not find   it useful, but it will silence a DEBUG message from Bazel regarding   reproducibility.   |  <code>None</code> |


<a name="#nuget_package"></a>

## nuget_package

<pre>
nuget_package(<a href="#nuget_package-name">name</a>, <a href="#nuget_package-package">package</a>, <a href="#nuget_package-version">version</a>, <a href="#nuget_package-nuget_sources">nuget_sources</a>, <a href="#nuget_package-sha256">sha256</a>, <a href="#nuget_package-build_file">build_file</a>, <a href="#nuget_package-build_file_content">build_file_content</a>)
</pre>

Download an external NuGet package.

At most one of build_file or build_file_content may be provided. If neither
are, a default BUILD file will be used that makes a "best effort" to wire
up the package. See docs/UsingNuGetPacakges.md for more info.


**PARAMETERS**


| Name  | Description | Default Value |
| :-------------: | :-------------: | :-------------: |
| name |  A unique name for the package's workspace.   |  none |
| package |  The name of the package in the NuGet feed.   |  none |
| version |  <p align="center"> - </p>   |  none |
| nuget_sources |  A list of nuget package sources. Defaults to nuget.org.   |  <code>None</code> |
| sha256 |  The SHA256 of the package.   |  <code>None</code> |
| build_file |  The path to a BUILD file to use for the package.   |  <code>None</code> |
| build_file_content |  A string containing the contents of a BUILD file.   |  <code>None</code> |


