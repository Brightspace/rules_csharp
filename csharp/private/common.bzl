load(
    "@d2l_rules_csharp//csharp/private:providers.bzl",
    "CSharpAssembly",
    "FrameworkCompatibility",
)

# TODO: make this configurable
DEFAULT_LANGVERSION = "7.3"

# TODO: make this configurable
DEFAULT_TARGET_FRAMEWORK = "net472"

def is_debug(ctx):
    # TODO: there are three modes: fastbuild, opt and dbg. fastbuild is supposed
    # to not output debug info (it's the default). We're treating fastbuild as
    # equivalent to dbg right now but might want to support this in the future.
    return ctx.var["COMPILATION_MODE"] != "opt"

def use_highentropyva(tfm):
    return tfm not in ["net20", "net40"]

def is_standard_framework(tfm):
    return tfm.startswith("netstandard")

def collect_transitive_info(deps, tfm):
    direct_refs = []
    transitive_refs = []
    direct_runfiles = []
    transitive_runfiles = []

    provider = CSharpAssembly[tfm]

    for dep in deps:
        if provider not in dep:
            fail("The dependency %s is not compatible with %s!" % (str(dep.label), tfm))

        assembly = dep[provider]

        # See docs/ReferenceAssemblies.md for more info on why we use refout
        direct_refs.append(assembly.refout or assembly.out)
        transitive_refs.append(assembly.transitive_refs)

        if assembly.out:
            direct_runfiles.append(assembly.out)
        if assembly.pdb:
            direct_runfiles.append(assembly.pdb)

        transitive_runfiles.append(assembly.transitive_runfiles)

    return (
        depset(direct = direct_refs, transitive = transitive_refs),
        depset(direct = direct_runfiles, transitive = transitive_runfiles),
    )

def fill_in_missing_frameworks(providers):
    """Creates extra providers for frameworks that are compatible with us.

    Since we may not have built this DLL for all possible frameworks that we're
    compatible with (e.g. we might have a net20 and net45 build, but no net40
    one) we "fill in the gaps" for our dependees.
    See docs/MultiTargetingDesign.md for more info.

    Args:
      providers: a dict from TFM to a provider.
      deps: the original deps used to generate the providers.
    """

    # iterate through the compatability table since it's in preference order
    for tfm in FrameworkCompatibility.keys():
        if tfm in providers:
            continue

        # There are at most 2 elements in FrameworkCompatibility[tfm], so this
        # nested loop isn't bad.
        for compatible_tfm in FrameworkCompatibility[tfm]:
            if compatible_tfm not in providers:
                continue

            # Copy the output from the compatible tfm, re-resolving the deps
            base = providers[compatible_tfm]
            (refs, runfiles) = collect_transitive_info(base.deps, tfm)
            providers[tfm] = CSharpAssembly[tfm](
                out = base.out,
                refout = base.refout,
                pdb = base.pdb,
                deps = base.deps,
                transitive_refs = refs,
                transitive_runfiles = runfiles,
            )
            break

def get_analyzer_dll(analyzer_target):
    return analyzer_target[CSharpAssembly["netstandard"]]
