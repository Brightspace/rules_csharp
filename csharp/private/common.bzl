load("@d2l_rules_csharp//csharp/private:providers.bzl", "CSharpAssembly_net472")

# TODO: make this configurable
DEFAULT_LANGVERSION = "7.3"

# TODO: make this configurable
DEFAULT_TARGET_FRAMEWORK = "net472"

def is_debug(ctx):
    # TODO: there are three modes: fastbuild, opt and dbg. fastbuild is supposed
    # to not output debug info (it's the default). We're treating fastbuild as
    # equivalent to dbg right now but might want to support this in the future.
    return ctx.var["COMPILATION_MODE"] != "opt"

def _resolve_dep(dep, wanted_provider):
    # easy case: we want X, they have X
    if wanted_provider in dep:
        return dep[wanted_provider]

    # TODO find the next best option if one exists (mirror msbuild behaviour).
    fail("Couldn't resolve dep to a compatible DLL")

def get_transitive_compile_refs(deps, provider):
    direct = []
    transitive = []

    for dep in deps:
        resolved_dep = _resolve_dep(dep, provider)

        direct.append(
            # If our dependency has a reference assembly, prefer it during
            # compilation. It results in better action caching. Some DLLs won't
            # have these though (especially external nuget packages) so if all
            # they have is the real DLL then we should use it.
            resolved_dep.refout or resolved_dep.out,
        )

        transitive.append(resolved_dep.transitive_compile_refs)

    return depset(direct = direct, transitive = transitive)

def get_target_framework_provider(tf_name):
    if tf_name == "net472":
        return CSharpAssembly_net472
    else:
        fail("Unexpected target framwork \"" + tf_name + "\".")

def get_analyzer_dll(analyzer_target):
    # I can't think of any reason to do anything other than find the newest
    # target framework provided by analyzer_target and use that.
    return analyzer_target[CSharpAssembly_net472].out
