load(
    "@d2l_rules_csharp//csharp/private:providers.bzl",
    "CSharpResource",
)

# Labels for the template and execution wrappers
_TEMPLATE = "@d2l_rules_csharp//csharp/private:wrappers/resx.cc"
_BASH_TEMPLATE = "@d2l_rules_csharp//csharp/private:wrappers/resx.bash"
_CSPROJ_TEMPLATE = "@d2l_rules_csharp//csharp/private:rules/ResGen.csproj"

def _csharp_resx_execv_impl(ctx):
    toolchain = ctx.toolchains["@d2l_rules_csharp//csharp/private:toolchain_type"]
    _, runfiles = toolchain.tool

    tool_path = ctx.attr.tool[DefaultInfo].files_to_run.executable.short_path
    ctx.actions.expand_template(
        template = ctx.file._bash_template,
        output = ctx.outputs.executable,
        substitutions = {
            "{DotNetExe}": "%s/%s" % (ctx.workspace_name, tool_path),
        },
        is_executable = True,
    )

    exec_runfiles = ctx.runfiles(files = [ctx.file._bash_runfiles])
    exec_runfiles = exec_runfiles.merge(runfiles)
    exec_runfiles = exec_runfiles.merge(ctx.attr.tool[DefaultInfo].default_runfiles)
    return [DefaultInfo(
        runfiles = exec_runfiles,
    )]

# Wrapper for calling dotnetw and the resx generation tool
# Merging of runfiles so that the code can execute as a single item
csharp_resx_execv = rule(
    implementation = _csharp_resx_execv_impl,
    executable = True,
    attrs = {
        "tool": attr.label(
            doc = "The tool responsible for generating a csproj file.",
            mandatory = True,
        ),
        "_bash_template": attr.label(
            doc = "The csproj template used in compiling the resx file.",
            default = Label(_BASH_TEMPLATE),
            allow_single_file = True,
        ),
        "_bash_runfiles": attr.label(
            doc = "The csproj template used in compiling the resx file.",
            # Need this to load the runfiles for bash
            default = Label("@bazel_tools//tools/bash/runfiles"),
            allow_single_file = True,
        ),
    },
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
)

def _csharp_resx_template_impl(ctx):
    if not ctx.attr.out:
        resource_name = ctx.attr.name
    else:
        resource_name = ctx.attr.out

    toolchain = ctx.toolchains["@d2l_rules_csharp//csharp/private:toolchain_type"]
    cc_file = ctx.actions.declare_file("%s.cc" % (ctx.attr.name))
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = cc_file,
        substitutions = {
            "{ResXFile}": "%s/%s" % (ctx.workspace_name, ctx.file.srcs.path),
            "{ResXManifest}": resource_name,
            "{CsProjTemplate}": "%s" % (ctx.file._csproj_template.short_path[3:]),
            "{NetFramework}": ctx.attr.target_framework,
            "{DotnetExe}": toolchain.runtime.executable.short_path[3:],
        },
    )
    return [
        DefaultInfo(
            files = depset(direct = [cc_file]),
        ),
    ]

# Describes the tool for generating a csproj that wraps a ResX file 
csharp_resx_template = rule(
    implementation = _csharp_resx_template_impl,
    attrs = {
        "srcs": attr.label(
            allow_single_file = True,
        ),
        "out": attr.string(
            doc = "Specifies the name of the output (.resources) resource file. The extension is not necessary.",
        ),
        "target_framework": attr.string(
            doc = "A target framework moniker used in building the resource file.",
            default = "netcoreapp3.0",
        ),
        "_template": attr.label(
            default = Label(_TEMPLATE),
            allow_single_file = True,
        ),
        "_csproj_template": attr.label(
            default = Label(_CSPROJ_TEMPLATE),
            allow_single_file = True,
        ),
    },
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
)

def _csharp_resx_build_impl(ctx):
    """_csharp_resx_impl emits actions for compiling a resx file."""
    if not ctx.attr.out:
        resource_name = ctx.attr.name
    else:
        resource_name = ctx.attr.out

    csproj = ctx.actions.declare_file(ctx.attr.csproj)
    args = ctx.actions.args()
    args.add("build")
    args.add(csproj.path)

    resource = ctx.actions.declare_file("obj/Debug/%s/%s.resources" % (ctx.attr.target_framework, resource_name))
    ctx.actions.run_shell(
        inputs = [ctx.file.srcs],
        outputs = [csproj, resource],
        tools = [ctx.executable.dotnet],
        # Temporary workaround to fix windows issue
        # TODO: Use arguments for passing the dotnet commands
        command = "%s %s %s" % (ctx.executable.dotnet.path, "build", csproj.path),
        mnemonic = "CompileResX",
        progress_message = "Compiling resx file to binary",
        use_default_shell_env = False,
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

# Runs the process for generating the csproj, then building it
csharp_resx_build = rule(
    implementation = _csharp_resx_build_impl,
    attrs = {
        "srcs": attr.label(
            doc = "The XML-based resource format (.resx) file.",
            mandatory = True,
            allow_single_file = True,
        ),
        "tool": attr.label(
            doc = "The tool responsible for generating a csproj file.",
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
        "dotnet": attr.label(
            doc = "The tool responsible for generating a csproj file.",
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
        "identifier": attr.string(
            doc = "The logical name for the resource; the name that is used to load the resource. The default is the name of the rule.",
        ),
        "out": attr.string(
            doc = "Specifies the name of the output (.resources) resource file. The extension is not necessary.",
        ),
        "csproj": attr.string(
            doc = "Specifies the name of the output (.resources) resource file. The extension is not necessary.",
        ),
        "target_framework": attr.string(
            doc = "A target framework moniker used in building the resource file.",
            default = "netcoreapp3.0",
        ),
        "_csproj_template": attr.label(
            doc = "The csproj template used in compiling the resx file.",
            default = Label(_CSPROJ_TEMPLATE),
            allow_single_file = True,
        ),
    },
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
    doc = """
Compiles an XML-based resource format (.resx) file into a binary resource (.resources) file.
""",
)

# Macro that connects the various rules
def csharp_resx(name, src):
    template = "%s-template" % (name)
    csproj = "%s-csproj" % (name)
    execv = "%s-execv" % (name)

    csharp_resx_template(
        name = template,
        srcs = src,
        out = name,
    )

    native.cc_binary(
        name = csproj,
        srcs = [template],
        data = [src, _CSPROJ_TEMPLATE],
        deps = ["@bazel_tools//tools/cpp/runfiles"],
    )

    csharp_resx_execv(
        name = execv,
        tool = csproj,
    )

    csharp_resx_build(
        name = name,
        srcs = src,
        tool = csproj,
        dotnet = execv,
        csproj = "%s-template.csproj" % (name),
    )
