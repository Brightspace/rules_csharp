load(
    "@d2l_rules_csharp//csharp/private:common.bzl",
    "get_transitive_compile_refs",
)
load("@d2l_rules_csharp//csharp/private:providers.bzl", "AnyTargetFramework", "CSharpAssembly")

def _import_library(ctx):
    files = []

    if ctx.file.dll == None and ctx.file.refdll == None:
        fail("At least one of dll or refdll must be specified")

    if ctx.file.dll != None:
        files += [ctx.file.dll]

    if ctx.file.pdb != None:
        files += [ctx.file.pdb]

    if ctx.file.refdll != None:
        files += [ctx.file.refdll]

    tf_provider = CSharpAssembly[ctx.attr.target_framework]

    return [
        DefaultInfo(
            files = depset(files),
        ),
        tf_provider(
            out = ctx.file.dll,
            refout = ctx.file.refdll,
            pdb = ctx.file.pdb,
            transitive_compile_refs = get_transitive_compile_refs(
                ctx.attr.deps,
                ctx.attr.target_framework,
            ),
        ),
    ]

import_library = rule(
    _import_library,
    doc = "Creates a target for a static C# DLL for a specific target framework",
    attrs = {
        "target_framework": attr.string(
            doc = "The target framework for this DLL",
            # mandatory = True,
            default = "net472",  # TODO: remove this default
        ),
        "dll": attr.label(
            doc = "A static DLL",
            allow_single_file = [".dll"],
        ),
        "pdb": attr.label(
            doc = "Debug symbols for the dll",
            allow_single_file = [".pdb"],
        ),
        "refdll": attr.label(
            doc = "A metadata-only DLL, suitable for compiling against but not running",
            allow_single_file = [".dll"],
        ),
        "deps": attr.label_list(
            doc = "other DLLs that this DLL depends on.",
            providers = AnyTargetFramework,
        ),
    },
    executable = False,
)
