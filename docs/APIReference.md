<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#csharp_binary"></a>

## csharp_binary

<pre>
csharp_binary(<a href="#csharp_binary-name">name</a>, <a href="#csharp_binary-additionalfiles">additionalfiles</a>, <a href="#csharp_binary-analyzers">analyzers</a>, <a href="#csharp_binary-defines">defines</a>, <a href="#csharp_binary-deps">deps</a>, <a href="#csharp_binary-include_stdrefs">include_stdrefs</a>, <a href="#csharp_binary-keyfile">keyfile</a>,
              <a href="#csharp_binary-langversion">langversion</a>, <a href="#csharp_binary-out">out</a>, <a href="#csharp_binary-resources">resources</a>, <a href="#csharp_binary-runtimeconfig_template">runtimeconfig_template</a>, <a href="#csharp_binary-srcs">srcs</a>, <a href="#csharp_binary-target_frameworks">target_frameworks</a>, <a href="#csharp_binary-winexe">winexe</a>)
</pre>

Compile a C# exe

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| additionalfiles |  Extra files to configure analyzers.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| analyzers |  A list of analyzer references.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| defines |  A list of preprocessor directive symbols to define.   | List of strings | optional | [] |
| deps |  Other C# libraries, binaries, or imported DLLs   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| include_stdrefs |  Whether to reference @net//:StandardReferences (the default set of references that MSBuild adds to every project).   | Boolean | optional | True |
| keyfile |  The key file used to sign the assembly with a strong name.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| langversion |  The version string for the C# language.   | String | optional | "" |
| out |  File name, without extension, of the built assembly.   | String | optional | "" |
| resources |  A list of files to embed in the DLL as resources.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| runtimeconfig_template |  A template file to use for generating runtimeconfig.json   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | :runtimeconfig.json.tpl |
| srcs |  C# source files.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| target_frameworks |  A list of target framework monikers to buildSee https://docs.microsoft.com/en-us/dotnet/standard/frameworks   | List of strings | optional | [] |
| winexe |  If true, output a winexe-style executable, otherwiseoutput a console-style executable.   | Boolean | optional | False |


<a name="#csharp_library"></a>

## csharp_library

<pre>
csharp_library(<a href="#csharp_library-name">name</a>, <a href="#csharp_library-additionalfiles">additionalfiles</a>, <a href="#csharp_library-analyzers">analyzers</a>, <a href="#csharp_library-defines">defines</a>, <a href="#csharp_library-deps">deps</a>, <a href="#csharp_library-include_stdrefs">include_stdrefs</a>, <a href="#csharp_library-keyfile">keyfile</a>,
               <a href="#csharp_library-langversion">langversion</a>, <a href="#csharp_library-out">out</a>, <a href="#csharp_library-resources">resources</a>, <a href="#csharp_library-srcs">srcs</a>, <a href="#csharp_library-target_frameworks">target_frameworks</a>)
</pre>

Compile a C# DLL

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| additionalfiles |  Extra files to configure analyzers.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| analyzers |  A list of analyzer references.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| defines |  A list of preprocessor directive symbols to define.   | List of strings | optional | [] |
| deps |  Other C# libraries, binaries, or imported DLLs   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| include_stdrefs |  Whether to reference @net//:StandardReferences (the default set of references that MSBuild adds to every project).   | Boolean | optional | True |
| keyfile |  The key file used to sign the assembly with a strong name.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| langversion |  The version string for the C# language.   | String | optional | "" |
| out |  File name, without extension, of the built assembly.   | String | optional | "" |
| resources |  A list of files to embed in the DLL as resources.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| srcs |  C# source files.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| target_frameworks |  A list of target framework monikers to buildSee https://docs.microsoft.com/en-us/dotnet/standard/frameworks   | List of strings | optional | [] |


<a name="#csharp_library_set"></a>

## csharp_library_set

<pre>
csharp_library_set(<a href="#csharp_library_set-name">name</a>, <a href="#csharp_library_set-deps">deps</a>, <a href="#csharp_library_set-target_framework">target_framework</a>)
</pre>

Defines a set of C# libraries to be depended on together

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| deps |  The set of libraries   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| target_framework |  The target framework for this set of libraries   | String | required |  |


<a name="#csharp_nunit_test"></a>

## csharp_nunit_test

<pre>
csharp_nunit_test(<a href="#csharp_nunit_test-name">name</a>, <a href="#csharp_nunit_test-additionalfiles">additionalfiles</a>, <a href="#csharp_nunit_test-analyzers">analyzers</a>, <a href="#csharp_nunit_test-defines">defines</a>, <a href="#csharp_nunit_test-deps">deps</a>, <a href="#csharp_nunit_test-include_stdrefs">include_stdrefs</a>, <a href="#csharp_nunit_test-keyfile">keyfile</a>,
                  <a href="#csharp_nunit_test-langversion">langversion</a>, <a href="#csharp_nunit_test-out">out</a>, <a href="#csharp_nunit_test-resources">resources</a>, <a href="#csharp_nunit_test-srcs">srcs</a>, <a href="#csharp_nunit_test-target_frameworks">target_frameworks</a>)
</pre>

Compile a C# exe

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| additionalfiles |  Extra files to configure analyzers.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| analyzers |  A list of analyzer references.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| defines |  A list of preprocessor directive symbols to define.   | List of strings | optional | [] |
| deps |  Other C# libraries, binaries, or imported DLLs   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| include_stdrefs |  Whether to reference @net//:StandardReferences (the default set of references that MSBuild adds to every project).   | Boolean | optional | True |
| keyfile |  The key file used to sign the assembly with a strong name.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| langversion |  The version string for the C# language.   | String | optional | "" |
| out |  File name, without extension, of the built assembly.   | String | optional | "" |
| resources |  A list of files to embed in the DLL as resources.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| srcs |  C# source files.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| target_frameworks |  A list of target framework monikers to buildSee https://docs.microsoft.com/en-us/dotnet/standard/frameworks   | List of strings | optional | [] |


<a name="#import_library"></a>

## import_library

<pre>
import_library(<a href="#import_library-name">name</a>, <a href="#import_library-deps">deps</a>, <a href="#import_library-dll">dll</a>, <a href="#import_library-native_dlls">native_dlls</a>, <a href="#import_library-pdb">pdb</a>, <a href="#import_library-refdll">refdll</a>, <a href="#import_library-target_framework">target_framework</a>)
</pre>

Creates a target for a static C# DLL for a specific target framework

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| deps |  other DLLs that this DLL depends on.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| dll |  A static DLL   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| native_dlls |  A list of native dlls, which while unreferenced, are required for running and compiling   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| pdb |  Debug symbols for the dll   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| refdll |  A metadata-only DLL, suitable for compiling against but not running   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| target_framework |  The target framework for this DLL   | String | required |  |


<a name="#import_multiframework_library"></a>

## import_multiframework_library

<pre>
import_multiframework_library(<a href="#import_multiframework_library-name">name</a>, <a href="#import_multiframework_library-net11">net11</a>, <a href="#import_multiframework_library-net20">net20</a>, <a href="#import_multiframework_library-net30">net30</a>, <a href="#import_multiframework_library-net35">net35</a>, <a href="#import_multiframework_library-net40">net40</a>, <a href="#import_multiframework_library-net403">net403</a>, <a href="#import_multiframework_library-net45">net45</a>, <a href="#import_multiframework_library-net451">net451</a>,
                              <a href="#import_multiframework_library-net452">net452</a>, <a href="#import_multiframework_library-net46">net46</a>, <a href="#import_multiframework_library-net461">net461</a>, <a href="#import_multiframework_library-net462">net462</a>, <a href="#import_multiframework_library-net47">net47</a>, <a href="#import_multiframework_library-net471">net471</a>, <a href="#import_multiframework_library-net472">net472</a>, <a href="#import_multiframework_library-net48">net48</a>,
                              <a href="#import_multiframework_library-netcoreapp1_0">netcoreapp1_0</a>, <a href="#import_multiframework_library-netcoreapp1_1">netcoreapp1_1</a>, <a href="#import_multiframework_library-netcoreapp2_0">netcoreapp2_0</a>, <a href="#import_multiframework_library-netcoreapp2_1">netcoreapp2_1</a>,
                              <a href="#import_multiframework_library-netcoreapp2_2">netcoreapp2_2</a>, <a href="#import_multiframework_library-netcoreapp3_0">netcoreapp3_0</a>, <a href="#import_multiframework_library-netstandard">netstandard</a>, <a href="#import_multiframework_library-netstandard1_0">netstandard1_0</a>,
                              <a href="#import_multiframework_library-netstandard1_1">netstandard1_1</a>, <a href="#import_multiframework_library-netstandard1_2">netstandard1_2</a>, <a href="#import_multiframework_library-netstandard1_3">netstandard1_3</a>, <a href="#import_multiframework_library-netstandard1_4">netstandard1_4</a>,
                              <a href="#import_multiframework_library-netstandard1_5">netstandard1_5</a>, <a href="#import_multiframework_library-netstandard1_6">netstandard1_6</a>, <a href="#import_multiframework_library-netstandard2_0">netstandard2_0</a>, <a href="#import_multiframework_library-netstandard2_1">netstandard2_1</a>)
</pre>

Aggregate import_library targets for specific target-frameworks into one target

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :-------------: | :-------------: | :-------------: | :-------------: | :-------------: |
| name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| net11 |  The net11 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net20 |  The net20 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net30 |  The net30 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net35 |  The net35 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net40 |  The net40 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net403 |  The net403 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net45 |  The net45 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net451 |  The net451 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net452 |  The net452 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net46 |  The net46 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net461 |  The net461 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net462 |  The net462 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net47 |  The net47 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net471 |  The net471 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net472 |  The net472 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| net48 |  The net48 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netcoreapp1_0 |  The netcoreapp1.0 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netcoreapp1_1 |  The netcoreapp1.1 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netcoreapp2_0 |  The netcoreapp2.0 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netcoreapp2_1 |  The netcoreapp2.1 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netcoreapp2_2 |  The netcoreapp2.2 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netcoreapp3_0 |  The netcoreapp3.0 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard |  The netstandard version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard1_0 |  The netstandard1.0 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard1_1 |  The netstandard1.1 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard1_2 |  The netstandard1.2 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard1_3 |  The netstandard1.3 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard1_4 |  The netstandard1.4 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard1_5 |  The netstandard1.5 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard1_6 |  The netstandard1.6 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard2_0 |  The netstandard2.0 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |
| netstandard2_1 |  The netstandard2.1 version of this library   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional | None |


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
| version |  The version of the package in the NuGet feed.   |  none |
| nuget_sources |  A list of nuget package sources. Defaults to nuget.org.   |  <code>None</code> |
| sha256 |  The SHA256 of the package.   |  <code>None</code> |
| build_file |  The path to a BUILD file to use for the package.   |  <code>None</code> |
| build_file_content |  A string containing the contents of a BUILD file.   |  <code>None</code> |


