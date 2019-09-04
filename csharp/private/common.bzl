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

def collect_transitive_info(deps, tfm):
    direct = []
    transitive = []
    provider = CSharpAssembly[tfm]

    for dep in deps:
        if provider not in dep:
            fail("The dependency %s is not compatible with %s!" % (str(dep.label), tfm))

        assembly = dep[provider]

        # See docs/ReferenceAssemblies.md for more info on why we use refout
        direct.append(assembly.refout or assembly.out)

        transitive.append(assembly.transitive_refs)

    return depset(direct = direct, transitive = transitive)

def _find_framework_gaps(providers):
    """Compute info about gaps in our providers to fill in.

    Returns a list of (base, framework set, start, end) tuples. Where:

    * "base" is the provider to use to "fill in" the gap
    * "framework set" is an index into FrameworkCompatability
    * "start" is an index into FrameworkCompatibility[framework set] for the
      first missing provider in the gap
    * "end" is likewise one past that last missing provider

    This function is written in a pretty complicated way and could use some
    more thought.

    Args:
      providers: a dict from tfm to provider
    """

    # 3 arrays, one for each framework set, where the values are the integers
    # for each tfm from that set that appears in providers.
    have = [[], [], []]

    for tfm in providers.keys():
        is_standard = tfm in FrameworkCompatibility[0]

        # Check every framework we have against the 3 compatibility sequences.
        for compat_seq_idx in [0, 1, 2]:
            if compat_seq_idx != 0 and is_standard:
                # TODO this algorithm is wrong and doesn't mix .NET Standard and
                # others correctly.
                continue

            if tfm in FrameworkCompatibility[compat_seq_idx]:
                fw_idx = FrameworkCompatibility[compat_seq_idx][tfm]
                have[compat_seq_idx].append(fw_idx)

    # Sort the have lists by priority, ascending. We add an extra number that's
    # higher priorty than all the other things in seq for the zip below.
    have = [sorted(seq) for seq in have]

    gap_sets = [
        # Create closed-open ranges of frameworks that are missing.
        zip(
            # Chose the provider that we have before this gap
            [providers[FrameworkCompatibility[idx].keys()[p]] for p in seq],
            # Indicate which compatibility set this gap refers to
            [idx for _ in seq],
            # We already have providers for things in seq, so each range by 1.
            [p + 1 for p in seq],
            # We need up to (but not including) the next framework we have. We
            # append the # of frameworks to the end for completeness.
            seq[1:] + [len(FrameworkCompatibility[idx])],
        )
        for (idx, seq) in enumerate(have)
    ]

    return gap_sets[0] + gap_sets[1] + gap_sets[2]

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

    for gap_info in _find_framework_gaps(providers):
        (base, compat_set_idx, start_idx, end_idx) = gap_info

        tfms = FrameworkCompatibility[compat_set_idx].keys()[start_idx:end_idx]

        # Copy the output from base and re-resolve deps for each tfm
        for tfm in tfms:
            refs = collect_transitive_info(base.deps, tfm)

            providers[tfm] = CSharpAssembly[tfm](
                out = base.out,
                refout = base.refout,
                pdb = base.pdb,
                deps = base.deps,
                transitive_refs = refs,
            )

def get_analyzer_dll(analyzer_target):
    return analyzer_target[CSharpAssembly["netstandard"]]
