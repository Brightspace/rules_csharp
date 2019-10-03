"""Define the CSharpAssembly_-prefixed providers

This module defines one provider per target framework and creates some handy
lookup tables for dealing with frameworks.

See docs/MultiTargetingDesign.md for more info.
"""

def _make_csharp_provider(tfm):
    return provider(
        doc = "A (usually C#) DLL or exe, targetting %s." % tfm,
        fields = {
            "out": "a dll (for libraries and tests) or an exe (for binaries).",
            "refout": "A reference-only DLL/exe. See docs/ReferenceAssemblies.md for more info.",
            "pdb": "debug symbols",
            "native_dlls": "A list of native DLLs required to build and run this assembly",
            "deps": "the non-transitive dependencies for this assembly (used by import_multiframework_library).",
            "transitive_refs": "A list of other assemblies to reference when referencing this assembly in a compilation.",
            "transitive_runfiles": "Runfiles from the transitive dependencies.",
            "actual_tfm": "The target framework of the actual dlls"
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

# A dict of target frameworks to the set of other framworks it can compile
# against. This relationship is transitive. The order of this dictionary also
# matters. netstandard should appear first, and keys within a family should
# proceed from oldest to newest
FrameworkCompatibility = {
    # .NET Standard
    "netstandard": [],
    "netstandard1.0": ["netstandard"],
    "netstandard1.1": ["netstandard1.0"],
    "netstandard1.2": ["netstandard1.1"],
    "netstandard1.3": ["netstandard1.2"],
    "netstandard1.4": ["netstandard1.3"],
    "netstandard1.5": ["netstandard1.4"],
    "netstandard1.6": ["netstandard1.5"],
    "netstandard2.0": ["netstandard1.6"],
    "netstandard2.1": ["netstandard2.0"],

    # .NET Framework
    "net20": [],
    "net40": ["net20"],
    "net45": ["net40", "netstandard1.1"],
    "net451": ["net45", "netstandard1.2"],
    "net452": ["net451"],
    "net46": ["net452", "netstandard1.3"],
    "net461": ["net46", "netstandard2.0"],
    "net462": ["net461"],
    "net47": ["net462"],
    "net471": ["net47"],
    "net472": ["net471"],
    "net48": ["net472"],

    # .NET Core
    "netcoreapp1.0": ["netstandard1.6"],
    "netcoreapp1.1": ["netcoreapp1.0"],
    "netcoreapp2.0": ["netcoreapp1.1", "netstandard2.0"],
    "netcoreapp2.1": ["netcoreapp2.0"],
    "netcoreapp2.2": ["netcoreapp2.1"],
    "netcoreapp3.0": ["netcoreapp2.2", "netstandard2.1"],
}

SubsystemVersion = {
    "netstandard": None,
    "netstandard1.0": None,
    "netstandard1.1": None,
    "netstandard1.2": None,
    "netstandard1.3": None,
    "netstandard1.4": None,
    "netstandard1.5": None,
    "netstandard1.6": None,
    "netstandard2.0": None,
    "netstandard2.1": None,
    "net20": None,
    "net40": None,
    "net45": "6.00",
    "net451": "6.00",
    "net452": "6.00",
    "net46": "6.00",
    "net461": "6.00",
    "net462": "6.00",
    "net47": "6.00",
    "net471": "6.00",
    "net472": "6.00",
    "net48": "6.00",
    "netcoreapp1.0": None,
    "netcoreapp1.1": None,
    "netcoreapp2.0": None,
    "netcoreapp2.1": None,
    "netcoreapp2.2": None,
    "netcoreapp3.0": None,
}

DefaultLangVersion = {
    "netstandard": "7.3",
    "netstandard1.0": "7.3",
    "netstandard1.1": "7.3",
    "netstandard1.2": "7.3",
    "netstandard1.3": "7.3",
    "netstandard1.4": "7.3",
    "netstandard1.5": "7.3",
    "netstandard1.6": "7.3",
    "netstandard2.0": "7.3",
    "netstandard2.1": "7.3",
    "net20": "7.3",
    "net40": "7.3",
    "net45": "7.3",
    "net451": "7.3",
    "net452": "7.3",
    "net46": "7.3",
    "net461": "7.3",
    "net462": "7.3",
    "net47": "7.3",
    "net471": "7.3",
    "net472": "7.3",
    "net48": "7.3",
    "netcoreapp1.0": "7.3",
    "netcoreapp1.1": "7.3",
    "netcoreapp2.0": "7.3",
    "netcoreapp2.1": "7.3",
    "netcoreapp2.2": "7.3",
    "netcoreapp3.0": "8.0",
}

# A convenience used in attributes that need to specify that they accept any
# kind of C# assembly. This is an array of single-element arrays.
AnyTargetFramework = [[a] for a in CSharpAssembly.values()]
