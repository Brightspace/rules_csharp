load(
    "@d2l_rules_csharp//csharp/private:providers.bzl",
    "CSharpResource",
)

# Label of the csproj template for ResX compilation
_TEMPLATE = "@d2l_rules_csharp//csharp/private:rules/ResGen.csproj"

# When compiling the csproj, it will look for the embedded resources related to
# the path of the csproj on disk. Since the csproj is written by the bazel, it will
# be in the rule bin directory. If we want to get the relative path to the
# ResX files, we need to get to a junction/symlink for the source.
#
# The junction/symlink that we are using is 4 directories up (\bazel-out\<sandbox>\bin\<name>\)
def _bazel_to_relative_path(path):
    return "../../../../%s" % (path)

def _csharp_resx_impl(ctx):
    """_csharp_resx_impl emits actions for compiling a resx file."""
    if not ctx.attr.out:
        resource_name = ctx.attr.name
    else:
        resource_name = ctx.attr.out

    csproj = ctx.actions.declare_file("%s.csproj" % (ctx.attr.name))
    resource = ctx.actions.declare_file("obj/Debug/%s/%s.resources" % (ctx.attr.target_framework, resource_name))

    ctx.actions.expand_template(
        template = ctx.file._csproj_template,
        output = csproj,
        substitutions = {
            "{TargetFramework}": ctx.attr.target_framework,
            "{Resx}": _bazel_to_relative_path(ctx.file.src.path),
            "{ManifestResourceName}": resource_name,
        },
    )

    toolchain = ctx.toolchains["@d2l_rules_csharp//csharp/private:toolchain_type"]

    args = ctx.actions.args()
    args.add("build")
    args.add(csproj.path)

    ctx.actions.run(
        inputs = [ctx.file.src, csproj],
        outputs = [resource],
        executable = toolchain.runtime,
        arguments = [args],
        mnemonic = "CompileResX",
        progress_message = "Compiling resx file to binary",
    )

    files = depset(direct = [resource])
    return [
        CSharpResource(
            name = ctx.attr.name,
            result = resource,
            identifier = resource.basename if not ctx.attr.identifier else ctx.attr.identifier,
        ),
        DefaultInfo(
            files = files,
        ),
    ]

csharp_resx = rule(
    implementation = _csharp_resx_impl,
    attrs = {
        "src": attr.label(
            doc = "The XML-based resource format (.resx) file.",
            mandatory = True,
            allow_single_file = True,
        ),
        "identifier": attr.string(
            doc = "The logical name for the resource; the name that is used to load the resource. The default is the name of the rule.",
        ),
        "out": attr.string(
            doc = "Specifies the name of the output (.resources) resource file. The extension is not necessary.",
        ),
        "target_framework": attr.string(
            doc = "A target framework moniker used in building the resource file.",
            default = "netcoreapp3.0",
        ),
        "_csproj_template": attr.label(
            doc = "The csproj template used in compiling the resx file.",
            default = Label(_TEMPLATE),
            allow_single_file = True,
        ),
    },
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
    doc = """
Compiles an XML-based resource format (.resx) file into a binary resource (.resources) file.
""",
)
