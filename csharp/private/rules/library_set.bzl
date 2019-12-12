# buildifier: disable=module-docstring
load(
    "//csharp/private:common.bzl",
    "collect_transitive_info",
    "fill_in_missing_frameworks",
)
load("//csharp/private:providers.bzl", "AnyTargetFramework", "CSharpAssembly")

def _library_set(ctx):
    files = []

    tfm = ctx.attr.target_framework

    (refs, runfiles, native_dlls) = collect_transitive_info(ctx.attr.deps, tfm)

    providers = {
        tfm: CSharpAssembly[tfm](
            out = None,
            refout = None,
            pdb = None,
            native_dlls = native_dlls,
            deps = ctx.attr.deps,
            transitive_refs = refs,
            transitive_runfiles = runfiles,
            actual_tfm = tfm,
        ),
    }

    fill_in_missing_frameworks(providers)

    return providers.values()

csharp_library_set = rule(
    _library_set,
    doc = "Defines a set of C# libraries to be depended on together",
    attrs = {
        "target_framework": attr.string(
            doc = "The target framework for this set of libraries",
            mandatory = True,
        ),
        "deps": attr.label_list(
            doc = "The set of libraries",
            providers = AnyTargetFramework,
        ),
    },
    executable = False,
)
