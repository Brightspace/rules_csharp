"""
Rules for compiling XML-based resource files.
"""

load(
    "//csharp/private:providers.bzl",
    "CSharpResourceInfo",
)

# Labels for the template and execution wrappers
_BASH_TEMPLATE = "//csharp/private:wrappers/resx.bash"
_CSPROJ_TEMPLATE = "//csharp/private:wrappers/ResGen.csproj"

def _get_resource_name(name, output_name):
    if not output_name:
        return name
    else:
        return output_name

def _csharp_resx_template_impl(ctx):
    """_csharp_resx_template_impl emits a shell script that will perform the compilation of a ResX using a CsProj wrapper."""
    toolchain = ctx.toolchains["//csharp/private:toolchain_type"]
    _, runfiles = toolchain.tool

    resource_name = _get_resource_name(ctx.attr.name, ctx.attr.out)
    script = ctx.actions.declare_file("%s.bash" % (ctx.attr.name))
    ctx.actions.expand_template(
        template = ctx.file._bash_template,
        output = script,
        substitutions = {
            "{ResXFile}": "%s/%s" % (ctx.workspace_name, ctx.file.src.path),
            "{ResXManifest}": resource_name,
            "{CsProjTemplate}": "%s" % (ctx.file._csproj_template.short_path[3:]),
            "{NetFramework}": ctx.attr.target_framework,
            "{DotNetExe}": toolchain.runtime.executable.short_path[3:],
        },
        is_executable = True,
    )
    exec_runfiles = ctx.runfiles(files = [
        ctx.file._bash_runfiles,
        ctx.file._csproj_template,
        ctx.file.src,
    ])
    exec_runfiles = exec_runfiles.merge(runfiles)
    return [DefaultInfo(
        executable = script,
        runfiles = exec_runfiles,
    )]

csharp_resx_template = rule(
    implementation = _csharp_resx_template_impl,
    attrs = {
        "src": attr.label(
            doc = "The XML-based resource format (.resx) file.",
            allow_single_file = True,
            mandatory = True,
        ),
        "out": attr.string(
            doc = """Specifies the name of the output (.resources) resource file. 
            The extension is not necessary. If not specified, the name of the rule will be used.""",
        ),
        "target_framework": attr.string(
            default = "netcoreapp3.0",
            doc = """A target framework moniker used in building the resource file.""",
        ),
        "_csproj_template": attr.label(
            default = Label(_CSPROJ_TEMPLATE),
            doc = """The CSProj template used to wrap the compilation of a ResX file.""",
            allow_single_file = True,
        ),
        "_bash_template": attr.label(
            default = Label(_BASH_TEMPLATE),
            doc = """The bash script that will be used as the base for csproj generation.""",
            allow_single_file = True,
        ),
        "_bash_runfiles": attr.label(
            default = Label("@bazel_tools//tools/bash/runfiles"),
            doc = "Bash runfiles for discovering a relative path to the ResX file.",
            allow_single_file = True,
        ),
    },
    executable = True,
    toolchains = ["//csharp/private:toolchain_type"],
)

def _csharp_resx_build_impl(ctx):
    """_csharp_resx_build_impl compiles the ResX file using the bash script."""
    toolchain = ctx.toolchains["//csharp/private:toolchain_type"]

    resource_name = _get_resource_name(ctx.attr.name, ctx.attr.out)
    csproj = ctx.actions.declare_file("%s.csproj" % (ctx.attr.name))
    resource = ctx.actions.declare_file("obj/Debug/%s/%s.resources" % (ctx.attr.target_framework, resource_name))
    ctx.actions.run_shell(
        inputs = [ctx.file.src],
        outputs = [csproj, resource],
        tools = [toolchain.runtime, ctx.executable.tool],
        command = ctx.executable.tool.path,
        mnemonic = "CompileResX",
        progress_message = "Compiling resx file to binary",
        use_default_shell_env = False,
        env = {
            "CsProjFile": csproj.path,
        },
    )

    files = depset(direct = [resource])
    return [
        CSharpResourceInfo(
            name = ctx.attr.name,
            result = resource,
            accessibility_modifier = ctx.attr.accessibility_modifier,
            identifier = resource.basename if not ctx.attr.identifier else ctx.attr.identifier,
        ),
        DefaultInfo(
            files = files,
        ),
    ]

csharp_resx_build = rule(
    implementation = _csharp_resx_build_impl,
    attrs = {
        "src": attr.label(
            doc = "The XML-based resource format (.resx) file.",
            allow_single_file = True,
            mandatory = True,
        ),
        "tool": attr.label(
            doc = """Tool that compiles an XML-based resource format (.resx) file into a binary resource""",
            cfg = "host",
            executable = True,
            mandatory = True,
        ),
        "identifier": attr.string(
            doc = "The logical name for the resource; the name that is used to load the resource. The default is the name of the rule.",
        ),
        "accessibility_modifier": attr.string(
            default = "public",
            doc = "The accessibility of the resource: public or private. The default is public.",
        ),
        "out": attr.string(
            doc = "Specifies the name of the output (.resources) resource file. The extension is not necessary.",
        ),
        "target_framework": attr.string(
            default = "netcoreapp3.0",
            doc = "A target framework moniker used in building the resource file.",
        ),
    },
    toolchains = ["//csharp/private:toolchain_type"],
    doc = """
Compiles an XML-based resource format (.resx) file into a binary resource (.resources) file.
""",
)

def csharp_resx(name, src):
    """
    Compiles an XML-based resource format (.resx) file into a binary resource (.resources) file.
    """
    template = "%s-template" % (name)

    csharp_resx_template(
        name = template,
        src = src,
        out = name,
    )

    csharp_resx_build(
        name = name,
        src = src,
        out = name,
        tool = template,
    )
