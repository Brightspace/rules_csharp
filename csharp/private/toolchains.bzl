def _csharp_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(            
            runtime = ctx.attr.runtime.files_to_run,
            compiler = ctx.file.compiler,
            tool = (
                ctx.workspace_name + "/" + ctx.attr.runtime.files_to_run.executable.short_path,
                ctx.attr.runtime.default_runfiles
            ),
        ),
    ]

csharp_toolchain = rule(
    _csharp_toolchain_impl,
    attrs = {
        "runtime": attr.label(
            executable = True,
            allow_single_file = True,
            mandatory = True,
            cfg = "host",
        ),
        "compiler": attr.label(
            executable = True,
            allow_single_file = True,
            mandatory = True,
            cfg = "host",
        ),
    },
)

# This is called in BUILD
def configure_toolchain(os, exe = "dotnetw"):
    csharp_toolchain(
        name = "csharp_x86_64-" + os,
        runtime = "@netcore-sdk-%s//:%s" % (os, exe),
        compiler = "@netcore-sdk-%s//:sdk/3.0.100/Roslyn/bincore/csc.dll" % (os),
    )

    native.toolchain(
        name = "csharp_%s_toolchain" % os,
        exec_compatible_with = [
            "@platforms//os:" + os,
            "@platforms//cpu:x86_64",
        ],

        toolchain = "csharp_x86_64-" + os,
        toolchain_type = ":toolchain_type",
    )
