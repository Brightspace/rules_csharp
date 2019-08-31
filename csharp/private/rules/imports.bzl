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

def _import_multiframework_library_impl(ctx):
  # Oh dear. I don't know of any way to do this better. ctx.attr is a struct
  # and it doesn't look like there's too much available to reflect on it.
  attrs = {
      "netstandard": ctx.attr.netstandard,
      "netstandard1.0": ctx.attr.netstandard1_0,
      "netstandard1.1": ctx.attr.netstandard1_1,
      "netstandard1.2": ctx.attr.netstandard1_2,
      "netstandard1.3": ctx.attr.netstandard1_3,
      "netstandard1.4": ctx.attr.netstandard1_4,
      "netstandard1.5": ctx.attr.netstandard1_5,
      "netstandard1.6": ctx.attr.netstandard1_6,
      "netstandard2.0": ctx.attr.netstandard2_0,
      "netstandard2.1": ctx.attr.netstandard2_1,
      "net20": ctx.attr.net20,
      "net40": ctx.attr.net40,
      "net45": ctx.attr.net45,
      "net451": ctx.attr.net451,
      "net452": ctx.attr.net452,
      "net46": ctx.attr.net46,
      "net461": ctx.attr.net461,
      "net462": ctx.attr.net462,
      "net47": ctx.attr.net47,
      "net471": ctx.attr.net471,
      "net472": ctx.attr.net472,
      "net48": ctx.attr.net48,
      "netcoreapp1.0": ctx.attr.netcoreapp1_0,
      "netcoreapp1.1": ctx.attr.netcoreapp1_1,
      "netcoreapp2.0": ctx.attr.netcoreapp2_0,
      "netcoreapp2.1": ctx.attr.netcoreapp2_1,
      "netcoreapp2.2": ctx.attr.netcoreapp2_2,
      "netcoreapp3.0": ctx.attr.netcoreapp3_0,
  }

  providers = []

  for (tfm, attr) in attrs.items():
      if attr != None:
          providers.append(attr[CSharpAssembly[tfm]])

  return providers

def _generate_multiframework_attrs():
    attrs = {}
    for (tfm, tf_provider) in CSharpAssembly.items():
        attrs[tfm.replace('.', '_')] = attr.label(
            doc = "The %s version of this library" % tfm,
            providers = [tf_provider],
        )

    return attrs

import_multiframework_library = rule(
    _import_multiframework_library_impl,
    doc = "Aggregate import_library targets for specific target-frameworks into one target",
    attrs = _generate_multiframework_attrs()
)
