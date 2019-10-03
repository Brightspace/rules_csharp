load(
    "@d2l_rules_csharp//csharp/private:providers.bzl",
    "AnyTargetFramework",
    "CSharpAssembly",
)

def _write_wrapper_cc_impl(ctx):
    provider = CSharpAssembly[ctx.attr.target_framework]
    exe = ctx.attr.exe[provider]

    toolchain = ctx.toolchains["@d2l_rules_csharp//csharp/private:toolchain_type"]

    ctx.actions.expand_template(
        template = ctx.files._main_cc[0],
        output = ctx.outputs.out,
        substitutions = {
            "{TargetExe}": exe.out.short_path,

            # Strip the leading "../" off the path to dotnet.exe
            "{DotnetExe}": toolchain.runtime.short_path[3:],

            "{RuntimeConfigJson}": ctx.file.runtimeconfig.short_path,
        },
    )

_write_wrapper_cc = rule(
    _write_wrapper_cc_impl,
    doc = "Write a .cc file that will wrap a C# exe",
    attrs = {
        "exe": attr.label(
            doc = "The exe to wrap",
            providers = AnyTargetFramework,
        ),
        "target_framework": attr.string(
            doc = "The target framework to choose at runtime",
            mandatory = True,
        ),
        "out": attr.output(
            doc = "The .cc file that gets output",
        ),
        "runtimeconfig": attr.label(
            doc = "A *.runtimeconfig.json file",
            allow_single_file = True,
            mandatory = True,
        ),
        "_main_cc": attr.label(
            doc = "The .cc file to use as a template",
            allow_single_file = [".cc"],
            default = ":main.cc",
        ),
    },
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
)

def _csharp_exe_impl(ctx):
    # Collect the C# providers from the exe
    csharp_providers = []
    for tf in CSharpAssembly.values():
        if tf in ctx.attr.exe:
            csharp_providers += [ctx.attr.exe[tf]]

    # Get the specific provider for the one we want to run
    provider = CSharpAssembly[ctx.attr.target_framework]
    exe = ctx.attr.exe[provider]


    # TODO: use bat for windows
    # We need to copy the wrapper because otherwise Bazel responds with this:
    #  'executable' provided by an executable rule '_csharp_exe' should be created by the same rule.
    # :(
    wrapper = ctx.attr.wrapper[DefaultInfo].files_to_run.executable
    out = ctx.actions.declare_file(ctx.attr.name)
    ctx.actions.run_shell(
        tools = [wrapper],
        outputs = [out],
        command = "cp -f \"$1\" \"$2\"",
        arguments = [wrapper.path, out.path],
        mnemonic = "CopyFile",
        progress_message = "Copying files",
        use_default_shell_env = True,
    )

    runtime_files = ctx.toolchains["@d2l_rules_csharp//csharp/private:toolchain_type"].all_runtime_files

    return csharp_providers + [DefaultInfo(
        executable = out,
        runfiles = ctx.runfiles(
            files = [wrapper, exe.out, exe.pdb, ctx.file.runtimeconfig] + runtime_files,
            transitive_files = exe.transitive_runfiles,
        ),
    )]

_csharp_exe = rule(
    _csharp_exe_impl,
    doc = "A wrapped C# exe suitable for bazel run/bazel test",
    attrs = {
        "target_framework": attr.string(
            doc = "The target framework to choose at runtime",
            mandatory = True,
        ),
        "wrapper": attr.label(
            doc = "A binary that invokes the target exe",
            mandatory = True,
        ),
        "exe": attr.label(
            doc = "The target exe",
            providers = AnyTargetFramework,
            mandatory = True,
        ),
        "runtimeconfig": attr.label(
            doc = "A *.runtimeconfig.json file",
            allow_single_file = True,
            mandatory = True,
        ),
    },
    executable = True,
    toolchains = ["@d2l_rules_csharp//csharp/private:toolchain_type"],
)

def wrap_csharp_exe(name, target_framework):
    cc_file = name + "-wrapper.cc"
    wrapper = name + "-wrapper"
    exe = name + "-unwrapped"

    runtimeconfig = "@d2l_rules_csharp//csharp/private/tools/assembly-runner:bazel.runtimeconfig.json"

    _write_wrapper_cc(
        name = name + "-wrapper-cc",
        target_framework = target_framework,
        exe = exe,
        out = cc_file,
        runtimeconfig = runtimeconfig,
    )

    native.cc_binary(
        name = wrapper,
        srcs = [cc_file],
        deps = ["@bazel_tools//tools/cpp/runfiles"],
    )

    _csharp_exe(
        name = name,
        target_framework = target_framework,
        wrapper = wrapper,
        exe = exe,
        runtimeconfig = runtimeconfig,
    )
