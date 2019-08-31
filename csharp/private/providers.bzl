def _make_csharp_provider(tfm):
    return provider(
        doc = "A (usually C#) DLL or exe, targetting %s. One of out or refout must exist." % tfm,
        fields = {
            "out": "a dll (for libraries and tests) or an exe (for binaries)." +
                   "This output is usable at runtime.",
            "refout": "A dll/exe but with all the implementations and" +
                      "non-visible symbols removed. This is sufficient to" +
                      "use when referencing an assembly at compile time and" +
                      "because it changes less frequently it will cache" +
                      "better. See" +
                      "https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/refout-compiler-option#remarks" +
                      "for more information.",
            "pdb": "debug symbols",
            "transitive_compile_refs": "A mix of out/refout's for all" +
                                       "transitive dependencies.",
        },
    )

# Bazel requires that providers be "top level" objects, so this stuff is a bit
# more boilerplate than it could otherwise be.
CSharpAssembly_netstandard = _make_csharp_provider("netstandard")
CSharpAssembly_netstandard10 = _make_csharp_provider("netstandard1.0")
CSharpAssembly_netstandard11 = _make_csharp_provider("netstandard1.1")
CSharpAssembly_netstandard12 = _make_csharp_provider("netstandard1.2")
CSharpAssembly_netstandard13 = _make_csharp_provider("netstandard1.3")
CSharpAssembly_netstandard14 = _make_csharp_provider("netstandard1.4")
CSharpAssembly_netstandard15 = _make_csharp_provider("netstandard1.5")
CSharpAssembly_netstandard16 = _make_csharp_provider("netstandard1.6")
CSharpAssembly_netstandard20 = _make_csharp_provider("netstandard2.0")
CSharpAssembly_netstandard21 = _make_csharp_provider("netstandard2.1")
CSharpAssembly_net20 = _make_csharp_provider("net20")
CSharpAssembly_net40 = _make_csharp_provider("net40")
CSharpAssembly_net45 = _make_csharp_provider("net45")
CSharpAssembly_net451 = _make_csharp_provider("net451")
CSharpAssembly_net452 = _make_csharp_provider("net452")
CSharpAssembly_net46 = _make_csharp_provider("net46")
CSharpAssembly_net461 = _make_csharp_provider("net461")
CSharpAssembly_net462 = _make_csharp_provider("net462")
CSharpAssembly_net47 = _make_csharp_provider("net47")
CSharpAssembly_net471 = _make_csharp_provider("net471")
CSharpAssembly_net472 = _make_csharp_provider("net472")
CSharpAssembly_net48 = _make_csharp_provider("net48")
CSharpAssembly_netcoreapp10 = _make_csharp_provider("netcoreapp1.0")
CSharpAssembly_netcoreapp11 = _make_csharp_provider("netcoreapp1.1")
CSharpAssembly_netcoreapp20 = _make_csharp_provider("netcoreapp2.0")
CSharpAssembly_netcoreapp21 = _make_csharp_provider("netcoreapp2.1")
CSharpAssembly_netcoreapp22 = _make_csharp_provider("netcoreapp2.2")
CSharpAssembly_netcoreapp30 = _make_csharp_provider("netcoreapp3.0")

# A dict from TFM to provider. The order of keys is not used.
CSharpAssembly = {
    "netstandard": CSharpAssembly_netstandard,
    "netstandard1.0": CSharpAssembly_netstandard10,
    "netstandard1.1": CSharpAssembly_netstandard11,
    "netstandard1.2": CSharpAssembly_netstandard12,
    "netstandard1.3": CSharpAssembly_netstandard13,
    "netstandard1.4": CSharpAssembly_netstandard14,
    "netstandard1.5": CSharpAssembly_netstandard15,
    "netstandard1.6": CSharpAssembly_netstandard16,
    "netstandard2.0": CSharpAssembly_netstandard20,
    "netstandard2.1": CSharpAssembly_netstandard21,
    "net20": CSharpAssembly_net20,
    "net40": CSharpAssembly_net40,
    "net45": CSharpAssembly_net45,
    "net451": CSharpAssembly_net451,
    "net452": CSharpAssembly_net452,
    "net46": CSharpAssembly_net46,
    "net461": CSharpAssembly_net461,
    "net462": CSharpAssembly_net462,
    "net47": CSharpAssembly_net47,
    "net471": CSharpAssembly_net471,
    "net472": CSharpAssembly_net472,
    "net48": CSharpAssembly_net48,
    "netcoreapp1.0": CSharpAssembly_netcoreapp10,
    "netcoreapp1.1": CSharpAssembly_netcoreapp11,
    "netcoreapp2.0": CSharpAssembly_netcoreapp20,
    "netcoreapp2.1": CSharpAssembly_netcoreapp21,
    "netcoreapp2.2": CSharpAssembly_netcoreapp22,
    "netcoreapp3.0": CSharpAssembly_netcoreapp30,
}

# These are ordered ascending in time.
_STANDARD_FRAMEWORKS = [
    "netstandard",
    "netstandard1.0",
    "netstandard1.1",
    "netstandard1.2",
    "netstandard1.3",
    "netstandard1.4",
    "netstandard1.5",
    "netstandard1.6",
    "netstandard2.0",
    "netstandard2.1",
]

# This is a dictionary from a TFM to the number of .NET standard versions that
# are compatible with that target framework. When the keys are enumerated they
# will come out in the same order as listed here in the code.
_LEGACY_FRAMEWORKS = {
    "net20": 0,
    "net40": 0,
    "net45": 3,  # up to netstandard1.1
    "net451": 4, # up to netstandard1.2
    "net452": 4,
    "net46": 5,  # up to netstandard1.3
    "net461": 5, # see NOTE below
    "net462": 5,
    "net47": 5,
    "net471": 5,
    "net472": 8, # up to netstandard2.0,
    "net48": 8,
}

# NOTE: Microsoft has this to say:
#   While NuGet considers .NET Framework 4.6.1 as supporting .NET Standard 1.5
#   through 2.0, there are several issues with consuming .NET Standard
#   libraries that were built for those versions from .NET Framework 4.6.1
#   projects. For .NET Framework projects that need to use such libraries, we
#   recommend that you upgrade the project to target .NET Framework 4.7.2 or
#   higher.
# https://docs.microsoft.com/en-us/dotnet/standard/net-standard#net-implementation-support
#
# We've deviated from NuGet's behaviour based on this scary sounding warning.

# See the note on _LEGACY_FRAMEWORKS for more info.
_CORE_FRAMEWORKS = {
    "netcoreapp1.0": 7, # up to netstandard 1.6,
    "netcoreapp1.1": 7,
    "netcoreapp2.0": 8, # up to netstandard 2.0
    "netcoreapp2.1": 8,
    "netcoreapp2.2": 8,
    "netcoreapp3.0": 9, # up to netstandard 2.1 (".NET 5")
}

def _generate_compatibility_for_nonstandard_frameworks(frameworks, compat):
    tfms = frameworks.keys()

    for (idx, tfm) in enumerate(tfms):
        std_level = frameworks[tfm]

        # All of the frameworks older than this one plus the applicable versions
        # of .NET standard. A framework from "frameworks" is always preferable to
        # a .NET standard framework.
        compat[tfm] = tfms[idx::-1] + _STANDARD_FRAMEWORKS[std_level::-1]

def _generate_compatibility_matrix():
    compat = {}

    # .NET Standard frameworks are backwards compatible with themselves
    for (idx, tfm) in enumerate(_STANDARD_FRAMEWORKS):
        compat[tfm] = _STANDARD_FRAMEWORKS[idx::-1]

    _generate_compatibility_for_nonstandard_frameworks(
        _LEGACY_FRAMEWORKS,
        compat
    )

    _generate_compatibility_for_nonstandard_frameworks(
        _CORE_FRAMEWORKS,
        compat
    )

    return compat

# This is intended to match the logic from NuGet. It's a mapping from TFM to
# the ordered list of TFMs compatible with it (in decreasing precedence).
CompatibleFrameworks = _generate_compatibility_matrix()

# A convenience used in attributes that need to specify that they accept any
# kind of C# assembly. This is an array of single-element arrays.
AnyTargetFramework = [[a] for a in CSharpAssembly.values()]
