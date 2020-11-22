"""
Base rule for compiling C# binaries and tests.
"""

load("//csharp/private:providers.bzl", "AnyTargetFrameworkInfo")
load("//csharp/private:actions/assembly.bzl", "AssemblyAction")
load(
    "//csharp/private:actions/misc.bzl",
    "write_internals_visible_to",
    "write_runtimeconfig"
)
load(
    "//csharp/private:common.bzl",
    "fill_in_missing_frameworks",
    "is_core_framework",
    "is_debug",
    "is_standard_framework",
)

def _binary_private_impl(ctx):
    providers = {}

    stdrefs = [ctx.attr._stdrefs] if ctx.attr.include_stdrefs else []

    internals_visible_to = write_internals_visible_to(
        ctx.actions,
        name = ctx.attr.name,
        others = ctx.attr.internals_visible_to,
    )

    for tfm in ctx.attr.target_frameworks:
        if is_standard_framework(tfm):
            fail("It doesn't make sense to build an executable for " + tfm)

        runtimeconfig = None
        if is_core_framework(tfm):
            runtimeconfig = write_runtimeconfig(
                ctx.actions,
                template = ctx.file.runtimeconfig_template,
                name = ctx.attr.name,
                tfm = tfm,
            )

        providers[tfm] = AssemblyAction(
            ctx.actions,
            name = ctx.attr.name,
            additionalfiles = ctx.files.additionalfiles,
            analyzers = ctx.attr.analyzers,
            debug = is_debug(ctx),
            defines = ctx.attr.defines,
            deps = ctx.attr.deps + stdrefs,
            internals_visible_to = internals_visible_to,
            keyfile = ctx.file.keyfile,
            langversion = ctx.attr.langversion,
            resources = ctx.files.resources,
            srcs = ctx.files.srcs,
            out = ctx.attr.out,
            target = "winexe" if ctx.attr.winexe else "exe",
            target_framework = tfm,
            toolchain = ctx.toolchains["@d2l_rules_csharp//csharp/private:toolchain_type"],
            runtimeconfig = runtimeconfig,
        )

    fill_in_missing_frameworks(providers)

    result = providers.values()

    direct_runfiles = [result[0].out, result[0].pdb]

    if result[0].runtimeconfig != None:
        direct_runfiles.append(result[0].runtimeconfig)

    result.append(DefaultInfo(
        executable = result[0].out,
        runfiles = ctx.runfiles(
            files = direct_runfiles,
            transitive_files = result[0].transitive_runfiles,
        ),
        files = depset([result[0].out, result[0].refout, result[0].pdb]),
    ))

    return result

csharp_binary_private = rule(
    _binary_private_impl,
    doc = """Compile a C# exe.
This is a private rule used to implement csharp_binary and should not be used directly.""",
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
        "winexe": attr.bool(
            doc = "If true, output a winexe-style executable, otherwise" +
                  "output a console-style executable.",
            default = False,
        ),
        "include_stdrefs": attr.bool(
            doc = "Whether to reference @net//:StandardReferences (the default set of references that MSBuild adds to every project).",
            default = True,
        ),
        "_stdrefs": attr.label(
            doc = "The standard set of assemblies to reference.",
            default = "@net//:StandardReferences",
        ),
        "runtimeconfig_template": attr.label(
            doc = "A template file to use for generating runtimeconfig.json",
            default = ":runtimeconfig.json.tpl",
            allow_single_file = True,
        ),
        "internals_visible_to": attr.string_list(
            doc = "Other C# libraries that can see the assembly's internal symbols. Using this rather than the InternalsVisibleTo assembly attribute will improve build caching.",
        ),
        "deps": attr.label_list(
            doc = "Other C# libraries, binaries, or imported DLLs",
            providers = AnyTargetFrameworkInfo,
        ),
    },
    executable = True,
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
)
