def _csharp_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            runtime = ctx.file.runtime,
            compiler = ctx.file.compiler,
            all_runtime_files = ctx.files.all_runtime_files,
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
        "all_runtime_files": attr.label(
            mandatory = True,
            cfg = "host",
        ),
    },
)

# This is called in BUILD
def configure_toolchain(os, exe = "dotnet"):
    csharp_toolchain(
        name = "csharp_x86_64-" + os,
        runtime = "@netcore-runtime-%s//:%s" % (os, exe),
        compiler = "@csharp-build-tools//:tasks/netcoreapp2.1/bincore/csc.dll",
        all_runtime_files = "@netcore-runtime-%s//:everything" % os,
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
