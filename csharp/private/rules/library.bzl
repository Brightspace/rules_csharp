"""
Rules for compiling C# libraries.
"""
load("//csharp/private:providers.bzl", "AnyTargetFrameworkInfo", "CSharpResource")
load("//csharp/private:actions/assembly.bzl", "AssemblyAction")
load(
    "//csharp/private:common.bzl",
    "fill_in_missing_frameworks",
    "is_debug",
)

def _library_impl(ctx):
    providers = {}

    stdrefs = [ctx.attr._stdrefs] if ctx.attr.include_stdrefs else []

    for tfm in ctx.attr.target_frameworks:
        providers[tfm] = AssemblyAction(
            ctx.actions,
            name = ctx.attr.name,
            additionalfiles = ctx.files.additionalfiles,
            analyzers = ctx.attr.analyzers,
            debug = is_debug(ctx),
            defines = ctx.attr.defines,
            deps = ctx.attr.deps + stdrefs,
            keyfile = ctx.file.keyfile,
            langversion = ctx.attr.langversion,
            resources = ctx.attr.resources,
            srcs = ctx.files.srcs,
            out = ctx.attr.out,
            target = "library",
            target_framework = tfm,
            toolchain = ctx.toolchains["@d2l_rules_csharp//csharp/private:toolchain_type"],
        )

    fill_in_missing_frameworks(providers)

    result = providers.values()
    result.append(DefaultInfo(
        files = depset([result[0].out]),
        default_runfiles = ctx.runfiles(files = [result[0].pdb]),
    ))

    return result

csharp_library = rule(
    _library_impl,
    doc = "Compile a C# DLL",
    attrs = {
        "srcs": attr.label_list(
            doc = "C# source files.",
            allow_files = [".cs"],
        ),
        "additionalfiles": attr.label_list(
            doc = "Extra files to configure analyzers.",
            allow_files = True,
        ),
        "analyzers": attr.label_list(
            doc = "A list of analyzer references.",
            providers = AnyTargetFrameworkInfo,
        ),
        "keyfile": attr.label(
            doc = "The key file used to sign the assembly with a strong name.",
            allow_single_file = True,
        ),
        "langversion": attr.string(
            doc = "The version string for the C# language.",
        ),
        "resources": attr.label_list(
            doc = "A list of files to embed in the DLL as resources.",
            allow_files = True,
            providers = [CSharpResource],
        ),
        "out": attr.string(
            doc = "File name, without extension, of the built assembly.",
        ),
        "target_frameworks": attr.string_list(
            doc = "A list of target framework monikers to build" +
                  "See https://docs.microsoft.com/en-us/dotnet/standard/frameworks",
            allow_empty = False,
        ),
        "defines": attr.string_list(
            doc = "A list of preprocessor directive symbols to define.",
            default = [],
            allow_empty = True,
        ),
        "include_stdrefs": attr.bool(
            doc = "Whether to reference @net//:StandardReferences (the default set of references that MSBuild adds to every project).",
            default = True,
        ),
        "_stdrefs": attr.label(
            doc = "The standard set of assemblies to reference.",
            default = "@net//:StandardReferences",
        ),
        "deps": attr.label_list(
            doc = "Other C# libraries, binaries, or imported DLLs",
            providers = AnyTargetFrameworkInfo,
        ),
    },
    executable = False,
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
)
