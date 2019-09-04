"""Define the CSharpAssembly_-prefixed providers

This module defines one provider per target framework and creates some handy
lookup tables for dealing with frameworks.

See docs/MultiTargetingDesign.md for more info.
"""

def _make_csharp_provider(tfm):
    return provider(
        doc = "A (usually C#) DLL or exe, targetting %s. One of out or refout must exist." % tfm,
        fields = {
            "out": "a dll (for libraries and tests) or an exe (for binaries).",
            "refout": "A reference-only DLL/exe. See docs/ReferenceAssemblies.md for more info.",
            "pdb": "debug symbols",
            "deps": "the non-transitive dependencies for this assembly (used by import_multiframework_library).",
            "transitive_refs": "A list of other assemblies to reference when referencing this assembly in a compilation.",
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

# A sequence of frameworks, each ordered ascending in time. The sequences are
# dicts from TFM to the index into that dicts keys (relying on the iteration
# order of Starlark dicts). These indexes are used to calculate priority. The
# order here is derived from NuGet (MSBuild's ProjectReference shares this
# logic, mercifully).
FrameworkCompatibility = [{
    # .NET Standard
    "netstandard": 0,
    "netstandard1.0": 1,
    "netstandard1.1": 2,
    "netstandard1.2": 3,
    "netstandard1.3": 4,
    "netstandard1.4": 5,
    "netstandard1.5": 6,
    "netstandard1.6": 7,
    "netstandard2.0": 8,
    "netstandard2.1": 9,
}, {
    # .NET Core
    "netstandard": 0,
    "netstandard1.0": 1,
    "netstandard1.1": 2,
    "netstandard1.2": 3,
    "netstandard1.3": 4,
    "netstandard1.4": 5,
    "netstandard1.5": 6,
    "netstandard1.6": 7,
    "netcoreapp1.0": 8,
    "netcoreapp1.1": 9,
    "netstandard2.0": 10,
    "netcoreapp2.0": 11,
    "netcoreapp2.1": 12,
    "netcoreapp2.2": 13,
    "netstandard2.1": 14,
    "netcoreapp3.0": 15,
}, {
    # .NET Framework
    "net20": 0,
    "net40": 1,
    "netstandard": 2,
    "netstandard1.0": 3,
    "netstandard1.1": 4,
    "net45": 5,
    "netstandard1.2": 6,
    "net451": 7,
    "net452": 8,
    "netstandard1.3": 9,
    "net46": 10,

    # NOTE: Microsoft has this to say:
    #   While NuGet considers .NET Framework 4.6.1 as supporting .NET Standard
    #   1.5 through 2.0, there are several issues with consuming .NET Standard
    #   libraries that were built for those versions from .NET Framework 4.6.1
    #   projects. For .NET Framework projects that need to use such libraries,
    #   we recommend that you upgrade the project to target .NET Framework
    #   4.7.2 or higher.
    # https://docs.microsoft.com/en-us/dotnet/standard/net-standard#net-implementation-support
    #
    # We've deviated from NuGet's behaviour based on this scary sounding
    # warning. We might want to reconsider this.
    "net461": 11,
    "net462": 12,
    "net47": 13,
    "net471": 14,
    "netstandard1.4": 15,
    "netstandard1.5": 16,
    "netstandard1.6": 17,
    "netstandard2.0": 18,
    "net472": 19,
    "net48": 20,
}]

# A convenience used in attributes that need to specify that they accept any
# kind of C# assembly. This is an array of single-element arrays.
AnyTargetFramework = [[a] for a in CSharpAssembly.values()]
