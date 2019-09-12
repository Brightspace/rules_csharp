# Multi-Targeting Design

### Contents

* [Usage](#usage)
* [Open issues](#open-issues)
* [How we want it to work](#how-we-want-it-to-work)
* [Implementation](#implementation)
  * [`import_library` vs `import_multiframework_library`](#import_library-vs-import_multiframework_library)
  * [The `CSharpAssembly_`-providers](#the-CSharpAssembly_-providers)
  * [The `fill_in_missing_frameworks` helper](#the-fill_in_missing_frameworks-helper)
* [Alternative designs](#alternative-designs)

The guiding principle for these rules is that they should be easy to use in
`BUILD` files and intuitive to C# users.

That means we need to support easy [multi-targeting](https://docs.microsoft.com/en-us/dotnet/standard/frameworks) 
(like MSBuild and NuGet) which involves picking the "right" DLL to reference
for every dependency during compilation, and which to use at run-time.
Multi-targeting is ubiquitous in the community (because of NuGet) and can be
crucial for maintaining a large code base.

The things we are trying to balance are:

* The `BUILD` API must be ergonomic and unsurprising (i.e. similar to MSBuild,
  which let's you multi-target by simply listing a set of frameworks in your
  csproj.
* Calculations for transitive dependencies need to be based on `depset`s to
  avoid "N^2" performance issues
* We should never coerce the `depset`s to lists (for performance).
* Even if a target supports multiple target frameworks, we should only compile
  the variants we actually need.

## Usage
Each target chooses which frameworks to compile against via the
`target_frameworks` attributes. An example:

```python
csharp_binary(
    name = "MyExe",
    srcs = [ /* ... */ ],
    target_frameworks = [
        "net45",
        "netcoreapp2.0"
    ],
    deps = [
        "MyLib",
        "@net//System.Linq",
    ]
)

csharp_library(
    name = "MyLib",
    srcs = [ /* ... */ ],
    target_frameworks = [
        "netstandard2.0",
        "net40",
    ],
)
```

In this example, we are instructing Bazel on how to compile `MyExe` for two
frameworks: `net45` and `netcoreapp2.0`. For the `@net//:System.Linq`
dependency, Bazel will use the variant from the respective framework, which
will be an exact match. For `MyLib`, Bazel will use the `net40` variant for
the `net45` build and the `netstandard2.0` version for the `netcoreapp2.0`.
Neither of these are exact matches, but they are compatible.`

If you invoke `bazel run :MyExe`, Bazel chooses the first framework listed in
`MyExe`s `target_frameworks` and will ensure that it has compiled `MyLib`
with `net40` and `MyExe` with `net45`. The other two compilations are not
required for `bazel run :MyExe`.

The `target_frameworks` attribute is optional. If it is not provided, a single
default framework will be chosen (currently `net472`, but configurable
per-workspace).

## Open issues

This isn't fully implemented yet. It works well enough for NuGet packages (e.g.
`csharp_nunit_test` pulls in NUnit pacakges under the hood) but it's a work in
progress. The most important open issues are:

* The logic for multi-targetting is complete, but until we download the
  framework DLLs for more frameworks we can only see this via external NuGet
	packages.
	* [Add additional .NET Frameworks](https://github.com/Brightspace/rules_csharp/issues/6)
	* [Add .NET Standard frameworks](https://github.com/Brightspace/rules_csharp/issues/7)
	* [Add .NET Core frameworks](https://github.com/Brightspace/rules_csharp/issues/8)
* [Make the "default framework" configurable](https://github.com/Brightspace/rules_csharp/issues/16)
* [Create @net targets](https://github.com/Brightspace/rules_csharp/issues/21)

## How we want it to work

Consider the following example of a diamond dependency (also available in [`examples/diamond/`](../examples/diamond/)):

```python
csharp_library(
    name = "Top",
    srcs = [/* ... */],
    target_frameworks=["net48"],
    deps = ["Left", "Right"],
)

csharp_library(
    name = "Left",
    srcs = [/* ... */],
    target_frameworks=["net45"],
    deps = ["Bottom"],
)

csharp_library(
    name = "Right",
    srcs = [/* ... */],
    target_frameworks=["netstandard2.0"],
    deps = ["Bottom"],
)

csharp_library(
    name = "Bottom",
    srcs = [/* ... */],
    target_frameworks=["net48", "net40", "netstandard1.4"],
    deps = ["@net//:System.Linq"],
)
```

`Bottom` has variants for frameworks `net48`, `net40`,  and `netstandard1.4`.
When we compile `Left` the correct choice to use for `Bottom` is `net40`.
When we compile `Right` the correct choice is `netstandard1.4`.

When we compile `Top`, we will use the `net45` variant of `Left` and the
`netstandard2.0` variant for `Right`, as these are both compatible with
`net48`. But what about `Bottom`? Neither of the choices that `Left` or `Right`
made are correct for `Top`. Instead, we choose the `net48` variant of `Bottom`.
This demonstrates that transitive references are not straight-forward.

We will end up compiling `Bottom` three times. In practice multi-targeting is
mostly likely to happen due to NuGet packages, which won't result in
recompilation. This is a pathelogical example meant to demonstrate the rules
concisely but is not realistic.

The phrase "(framework) X is compatible with (framework Y" means that
assemblies compiled against X can be referenced when compiling against Y.
Compatability is non-commutative. If X is compatible with Y, and Y is
compatible with X, then X and Y must be the same framework.

For a concrete example, `net472` is compatible with `net48`. The precise rules
for compatibility we use are derived from NuGet/`ProjectReference` (part of
MSBuild).

This behaviour matches MSBuild (TODO: check the MSBuild version of this in to
`examples/` along with the BUILD file).

## Implementation

To enable Bazel to make these computations we:

1. Have one provider per framework
2. If a target has a provider for framework Y, and framework X is compatible
   with Y, then the target also has a provider for X.
3. If X is not compatible with anything in `target_frameworks` for a particular
   target, then there is no X-provider for that target. 

To make (2) concrete, in `Bottom` from the above example we will have a
`net45` provider even though it isn't listed in `target_frameworks`. It will
use the build output from the `net40` compilation of `Bottom`, but will
calculate the transitive dependencies as if it was building for `net45`. So it
will reference the `net45` variant of `@net//:System.Linq`.

### `import_library` vs `import_multiframework_library`

The `import_library` rule can be used to create a target from a single static
DLL. To take a set of DLLs, each variants of the same assembly for different
frameworks, and create a single target you can use
`import_multiframework_library`. Typically you would make your `import_library`
rules private, and have increased visibility for your
`import_multiframework_library` target.

For an example of how this is done, see [how we import NUnit](../csharp/private/nunit/nunitframework.BUILD).
Note that the plan is to do this by default for NuGet packages (with a macro
in a default BUILD file) soon (issue [#22](https://github.com/Brightspace/rules_csharp/issues/22)).

### The `CSharpAssembly_`-providers

Each framework gets it's own provider. For example, [`CSharpAssembly_net462`](APIReference.md#CSharpAssembly_net462).
When you are referencing a dependency, we look up its framework in its
dependencies providers. If it doesn't exist then the build fails (because the
dependency is not compatible). If it does, we can form `depset`s (of `File`
objects) from the information in the dependency providers. 

Each provider lists the build output (`out`/`refout`/`pdb`) and transitive
`depset`s of `File`s (`transitive_refs`/`transitive_runfiles`).
The providers for non-transitive dependencies are also stored in `deps`. This
is used by `import_multiframework_library` which is capable (unlike, for
example, `csharp_library`) of handling the scenario where different variants
of an assembly have different dependencies.

### The `fill_in_missing_frameworks` helper

We output a provider per framwork listed in `target_frameworks`, but because of
(2) above we need to output additional providers for other frameworks. These
additional providers aid dependers by caching assembly resolution for the
necessary target framework via `depset`s.

This is done by the helper function `fill_in_missing_frameworks`. It works
from most-compatible to least-compatible framework, "filling in" missing
providers when there is a compatible replacement by reusing the compatible
frameworks build output and recalculating the transitive dependencies.

This design was chosen so that the computations could be based on `depset`s
without coercing them to lists during analysis time, and so that the inputs
list to the compilation action is minimal.

## Alternative designs

We could instead collect `(label, precedence, provider)` triples, where
`precedence` is an integer, and pass this down to the compiler. This would
require a wrapper around the compiler (csc expects its user to have reduced
the references to an unambiguous set) which isn't so bad, but it would also
require adding many more DLLs to the inputs for an action. This raises two
problems:

1. We would need to compile more DLLs then necessary. For example, we would
   need to compile both variants of `:MyLib` in the `bazel run` example above,
   rather than just the `net40` variant. This is unavoidable.
2. We would have worse action caching. This could be partial mitigated by
   using [unused_inputs_list](https://docs.bazel.build/versions/master/skylark/lib/actions.html#run)
   but that's not perfect either.

If we kept the resolution in Starlark as far as I can tell we'd need to stop
using `depset` which could be a performance problem.

We could use macros to generate calls to per-framework rules (or configure
exactly one framework per rule invocation) but at best we'd get the same API
we'd have now and that macro would be just as complicated as our rules. This is
the approach that [rules_dotnet](https://github.com/bazelbuild/rules_dotnet)
uses, but it pushes the complexity of resolving the right DLLs onto the user
which we find to be unacceptable.
