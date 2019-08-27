# rules_csharp

[Bazel](https://bazel.build) rules for C#.

These are experimental and initially were built for use by D2L.
You probably want to use [bazelbuild/rules_dotnet](https://github.com/bazelbuild/rules_dotnet).
These are in a rougher state but they contain some differences that are
important for us. Our (potentially long-term) goal is to upstream the
differences, somehow, with the community.

Our goal is to get a set of rules that are ergonomic (even with multiple target
frameworks), performant (using reference assemblies, persistent workers, etc.),
cross-platform and as simple as possible given those constraints.

## Differences from rules_dotnet

* No support for Mono
  * Differences between mcs/csc make supporting both an extra challenge
  * We're not against supporting Mono! We just don't use it ourselves.
* We have one toolchain for Mac, Linux and Windows
  * The toolchain is responsible for running .NET code (i.e. the runtime)
  * It also includes a compiler for the host
  * Any toolchain can compile .NET for any target (in the Bazel sense) or
    target framework (in the Microsoft sense). That is, it is possible to
    compile .NET 4.8 assemblies on Linux, even though they can only be
    run on Windows.
* We only have one `_binary`/`_library`/`_nunit_test` rule. Target frameworks
  are supported by a `target_frameworks = [ ... ]` attribute on each rule.
  * Currently only `net472` is supported but we hope to expand this
  * This works by having targets output one provider per target framework.
* We use [reference assemblies](https://github.com/dotnet/roslyn/blob/master/docs/features/refout.md)
  at compile time as much as possible to improve caching.
  * Most NuGet packages don't ship with these, naturally, so we fall back to
    referencing DLLs when reference assemblies aren't available
  * If you have a deep dependency tree, what ends up happening is that often
    changes to your core libraries don't cause recompiles of downstream
    assemblies. Since the real DLLs are necessary at runtime the unit tests
    will still need to be rerun, of course.
* Sandbox compatible (even if Windows doesn't really have a sandbox yet).
  * Avoid using the GAC in Windows at compile time
  * Never use the system's compiler/tools
* We wrap VBCSCompiler in a persistent worker for improved
  performance/memory usage
  * This hasn't been extracted to the open-source repo yet.
