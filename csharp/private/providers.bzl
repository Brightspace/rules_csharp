def _make_csharp_provider():
    return provider(
        doc = "A (usually C#) DLL or exe. One of out or refout must exist.",
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

CSharpAssembly_net472 = _make_csharp_provider()

# TODO other target frameworks

# A convenience used in attributes that need to specify that they accept any
# kind of C# assembly.
AnyTargetFramework = [
    [CSharpAssembly_net472],
]
