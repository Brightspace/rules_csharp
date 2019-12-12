"""Define the CSharp providers for each .NET framework

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
            "actual_tfm": "The target framework of the actual dlls",
        },
    )

# Bazel requires that providers be "top level" objects, so this stuff is a bit
# more boilerplate than it could otherwise be.
CSharpNetStandardAssemblyInfo = _make_csharp_provider("netstandard")
CSharpNetStandard10AssemblyInfo = _make_csharp_provider("netstandard1.0")
CSharpNetStandard11AssemblyInfo = _make_csharp_provider("netstandard1.1")
CSharpNetStandard12AssemblyInfo = _make_csharp_provider("netstandard1.2")
CSharpNetStandard13AssemblyInfo = _make_csharp_provider("netstandard1.3")
CSharpNetStandard14AssemblyInfo = _make_csharp_provider("netstandard1.4")
CSharpNetStandard15AssemblyInfo = _make_csharp_provider("netstandard1.5")
CSharpNetStandard16AssemblyInfo = _make_csharp_provider("netstandard1.6")
CSharpNetStandard20AssemblyInfo = _make_csharp_provider("netstandard2.0")
CSharpNetStandard21AssemblyInfo = _make_csharp_provider("netstandard2.1")
CSharpNet11AssemblyInfo = _make_csharp_provider("net11")
CSharpNet20AssemblyInfo = _make_csharp_provider("net20")
CSharpNet30AssemblyInfo = _make_csharp_provider("net30")
CSharpNet35AssemblyInfo = _make_csharp_provider("net35")
CSharpNet40AssemblyInfo = _make_csharp_provider("net40")
CSharpNet403AssemblyInfo = _make_csharp_provider("net403")
CSharpNet45AssemblyInfo = _make_csharp_provider("net45")
CSharpNet451AssemblyInfo = _make_csharp_provider("net451")
CSharpNet452AssemblyInfo = _make_csharp_provider("net452")
CSharpNet46AssemblyInfo = _make_csharp_provider("net46")
CSharpNet461AssemblyInfo = _make_csharp_provider("net461")
CSharpNet462AssemblyInfo = _make_csharp_provider("net462")
CSharpNet47AssemblyInfo = _make_csharp_provider("net47")
CSharpNet471AssemblyInfo = _make_csharp_provider("net471")
CSharpNet472AssemblyInfo = _make_csharp_provider("net472")
CSharpNet48AssemblyInfo = _make_csharp_provider("net48")
CSharpNetCoreApp10AssemblyInfo = _make_csharp_provider("netcoreapp1.0")
CSharpNetCoreApp11AssemblyInfo = _make_csharp_provider("netcoreapp1.1")
CSharpNetCoreApp20AssemblyInfo = _make_csharp_provider("netcoreapp2.0")
CSharpNetCoreApp21AssemblyInfo = _make_csharp_provider("netcoreapp2.1")
CSharpNetCoreApp22AssemblyInfo = _make_csharp_provider("netcoreapp2.2")
CSharpNetCoreApp30AssemblyInfo = _make_csharp_provider("netcoreapp3.0")

# A dict from TFM to provider. The order of keys is not used.
CSharpAssemblyInfo = {
    "netstandard": CSharpNetStandardAssemblyInfo,
    "netstandard1.0": CSharpNetStandard10AssemblyInfo,
    "netstandard1.1": CSharpNetStandard11AssemblyInfo,
    "netstandard1.2": CSharpNetStandard12AssemblyInfo,
    "netstandard1.3": CSharpNetStandard13AssemblyInfo,
    "netstandard1.4": CSharpNetStandard14AssemblyInfo,
    "netstandard1.5": CSharpNetStandard15AssemblyInfo,
    "netstandard1.6": CSharpNetStandard16AssemblyInfo,
    "netstandard2.0": CSharpNetStandard20AssemblyInfo,
    "netstandard2.1": CSharpNetStandard21AssemblyInfo,
    "net11": CSharpNet11AssemblyInfo,
    "net20": CSharpNet20AssemblyInfo,
    "net30": CSharpNet30AssemblyInfo,
    "net35": CSharpNet35AssemblyInfo,
    "net40": CSharpNet40AssemblyInfo,
    "net403": CSharpNet403AssemblyInfo,
    "net45": CSharpNet45AssemblyInfo,
    "net451": CSharpNet451AssemblyInfo,
    "net452": CSharpNet452AssemblyInfo,
    "net46": CSharpNet46AssemblyInfo,
    "net461": CSharpNet461AssemblyInfo,
    "net462": CSharpNet462AssemblyInfo,
    "net47": CSharpNet47AssemblyInfo,
    "net471": CSharpNet471AssemblyInfo,
    "net472": CSharpNet472AssemblyInfo,
    "net48": CSharpNet48AssemblyInfo,
    "netcoreapp1.0": CSharpNetCoreApp10AssemblyInfo,
    "netcoreapp1.1": CSharpNetCoreApp11AssemblyInfo,
    "netcoreapp2.0": CSharpNetCoreApp20AssemblyInfo,
    "netcoreapp2.1": CSharpNetCoreApp21AssemblyInfo,
    "netcoreapp2.2": CSharpNetCoreApp22AssemblyInfo,
    "netcoreapp3.0": CSharpNetCoreApp30AssemblyInfo,
}

# A dict of target frameworks to the set of other framworks it can compile
# against. This relationship is transitive. The order of this dictionary also
# matters. netstandard should appear first, and keys within a family should
# proceed from oldest to newest
FRAMEWORK_COMPATIBILITY = {
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
    "net11": [],
    "net20": ["net11"],
    "net30": ["net20"],
    "net35": ["net30"],
    "net40": ["net35"],
    "net403": ["net40"],
    "net45": ["net403", "netstandard1.1"],
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

_subsystem_version = {
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
    "net11": None,
    "net20": None,
    "net30": None,
    "net35": None,
    "net40": None,
    "net403": None,
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

_default_lang_version = {
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
    "net11": "7.3",
    "net20": "7.3",
    "net30": "7.3",
    "net35": "7.3",
    "net40": "7.3",
    "net403": "7.3",
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

def GetFrameworkVersionInfo(tfm):
    return (
        _subsystem_version[tfm],
        _default_lang_version[tfm],
    )

# A convenience used in attributes that need to specify that they accept any
# kind of C# assembly. This is an array of single-element arrays.
AnyTargetFrameworkInfo = [[a] for a in CSharpAssemblyInfo.values()]
