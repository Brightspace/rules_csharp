def _csharp_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            runtime = ctx.file.runtime,
            compiler = ctx.file.compiler,
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
def configure_toolchain(os, exe = "dotnet"):
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
