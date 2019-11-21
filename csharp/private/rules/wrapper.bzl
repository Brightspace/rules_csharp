def _dotnet_wrapper_impl(ctx):
    cc_file = ctx.actions.declare_file("%s.cc" % (ctx.attr.name))
    ctx.actions.expand_template(
        template = ctx.file.src,
        output = cc_file,
        substitutions = {
            "{DotnetExe}": ctx.files.target[0].short_path[3:],
        },
    )

    files = depset(direct = [cc_file])
    return [
        DefaultInfo(
            files = files,
        ),
    ]

dotnet_wrapper = rule(
    implementation = _dotnet_wrapper_impl,
    attrs = {
        "src": attr.label(
            mandatory = True, 
            allow_single_file = True
        ),
        "target": attr.label_list(
            mandatory = True, 
            allow_files = True,
        ),
    },
)