# Reference Assemblies

We make extensive use of [reference assemblies](https://github.com/dotnet/standard/blob/master/docs/history/evolution-of-design-time-assemblies.md)
in these rules to improve build performance. They are the C# equivalent of
[Google's ijar](https://github.com/bazelbuild/bazel/tree/master/third_party/ijar)
tool for Java.

In short, a reference assembly for x is a striped down version of an assembly
that only contains information necessary for compiling other assemblies that
must reference x. In other words, it's the "public API" for x. See the link
above for more details.

This is extremely important for transitive dependencies. At D2L We have over a
thousand DLLs that depend on some of our core DLLs. Changes to these core DLLs
require running all downstream tests (there is no way around this generally for
a correct build) but with reference assemblies we are often able to skip the
compilation of downstream assemblies.

## `csharp_library`/`csharp_binary`/`csharp_nunit_test`

The rules that create compilation actions automatically instruct the compiler
to generate a reference assembly alongside the proper assembly. Information
about both files is available via the `CSharpAssembly_`-prefixed providers.

## `import_library`

The `import_library` rule allows you to specify `refdll` without specifying
`dll`. This is useful for things like the .NET Framework, where it is expected
that you get these `dll`s at runtime from the Global Assembly Cache (GAC). We
just don't want to use the GAC at compile-time for reproducibility across
machines.

If you don't provide `dll` for an `import_library`, we won't include anything
in the runfiles. So there is a chance that your output will not be runnable if
this is over-used.