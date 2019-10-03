load("@d2l_rules_csharp//csharp/private:providers.bzl", "AnyTargetFramework")
load("@d2l_rules_csharp//csharp/private:actions/assembly.bzl", "AssemblyAction")
load(
    "@d2l_rules_csharp//csharp/private:common.bzl",
    "fill_in_missing_frameworks",
    "is_debug",
    "is_standard_framework",
)

def _nunit_test_impl(ctx):
    providers = {}

    extra_deps = [ctx.attr._nunitlite, ctx.attr._nunitframework]
    stdrefs = [ctx.attr._stdrefs] if ctx.attr.include_stdrefs else []

    for tfm in ctx.attr.target_frameworks:
        if is_standard_framework(tfm):
            fail("It doesn't make sense to build an executable for " + tfm)

        providers[tfm] = AssemblyAction(
            ctx.actions,
            name = ctx.attr.name,
            additionalfiles = ctx.files.additionalfiles,
            analyzers = ctx.attr.analyzers,
            debug = is_debug(ctx),
            defines = ctx.attr.defines,
            deps = ctx.attr.deps + extra_deps + stdrefs,
            keyfile = ctx.file.keyfile,
            langversion = ctx.attr.langversion,
            resources = ctx.files.resources,
            srcs = ctx.files.srcs + [ctx.file._nunit_shim],
            out = ctx.attr.out,
            target = "exe",
            target_framework = tfm,
            toolchain = ctx.toolchains["@d2l_rules_csharp//csharp/private:toolchain_type"],
        )

    fill_in_missing_frameworks(providers)

    result = providers.values()
    result.append(DefaultInfo(
        executable = result[0].out,
        runfiles = ctx.runfiles(
            files = [result[0].out, result[0].pdb],
            transitive_files = result[0].transitive_runfiles,
        ),
        files = depset([result[0].out, result[0].refout, result[0].pdb]),
    ))

    return result

csharp_nunit_test = rule(
    _nunit_test_impl,
    doc = "Compile a C# exe",
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
            providers = AnyTargetFramework,
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
            providers = AnyTargetFramework,
        ),
        "_nunit_shim": attr.label(
            doc = "Entry point for NUnitLite",
            allow_single_file = [".cs"],
            default = "@d2l_rules_csharp//csharp/private:nunit/shim.cs",
        ),
        "_nunitlite": attr.label(
            doc = "The NUnitLite library",
            providers = AnyTargetFramework,
            default = "@NUnitLite//:nunitlite",
        ),
        "_nunitframework": attr.label(
            doc = "The NUnit framework",
            providers = AnyTargetFramework,
            default = "@NUnit//:nunit.framework",
        ),
    },
    test = True,
    executable = True,
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
)
