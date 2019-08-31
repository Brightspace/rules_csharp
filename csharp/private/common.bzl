load("@d2l_rules_csharp//csharp/private:providers.bzl", "CompatibleFrameworks", "CSharpAssembly")

# TODO: make this configurable
DEFAULT_LANGVERSION = "7.3"

# TODO: make this configurable
DEFAULT_TARGET_FRAMEWORK = "net472"

def is_debug(ctx):
    # TODO: there are three modes: fastbuild, opt and dbg. fastbuild is supposed
    # to not output debug info (it's the default). We're treating fastbuild as
    # equivalent to dbg right now but might want to support this in the future.
    return ctx.var["COMPILATION_MODE"] != "opt"

def _resolve_dep(dep, desired_tfm):
    # easy case: we want X, they have X
    compatible_tfms = CompatibleFrameworks[desired_tfm]

    for possible_tfm in compatible_tfms:
        tf_provider = CSharpAssembly[possible_tfm]
        if tf_provider in dep:
            return dep[tf_provider]

    fail("The dependency %s is not compatible with %s!" % (str(dep.label), desired_tfm))

def get_transitive_compile_refs(deps, desired_tfm):
    direct = []
    transitive = []

    for dep in deps:
        resolved_dep = _resolve_dep(dep, desired_tfm)

        direct.append(
            # If our dependency has a reference assembly, prefer it during
            # compilation. It results in better action caching. Some DLLs won't
            # have these though (especially external nuget packages) so if all
            # they have is the real DLL then we should use it.
            resolved_dep.refout or resolved_dep.out,
        )

        transitive.append(resolved_dep.transitive_compile_refs)

    return depset(direct = direct, transitive = transitive)

def get_analyzer_dll(analyzer_target):
    return analyzer_target[CSharpAssembly["netstandard"]]
