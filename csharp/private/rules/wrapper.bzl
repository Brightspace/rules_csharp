"""
A wrapper around `dotnet` for Bazel.
"""

def _dotnet_wrapper_impl(ctx):
    if len(ctx.attr.args) > 2:
      fail("args is too long")

    main_cc = ctx.actions.declare_file("%s.main.cc" % ctx.attr.name)

    # Trim leading "../"
    # e.g. ../netcore-sdk-osx/dotnet
    dotnetexe_path = ctx.files.dotnet[0].short_path[3:]

    ctx.actions.expand_template(
        template = ctx.file.template,
        output = main_cc,
        substitutions = {
            "{DotnetExe}": dotnetexe_path,
            "{Argv1}": ctx.attr.args[0] if len(ctx.attr.args) > 0 else "",
            "{Argv2}": ctx.attr.args[1] if len(ctx.attr.args) > 1 else "",
        },
    )

    files = depset(direct = [main_cc])
    return [
        DefaultInfo(
            files = files,
        ),
    ]

dotnet_wrapper = rule(
    implementation = _dotnet_wrapper_impl,
    attrs = {
        "template": attr.label(
            doc = """Path to the program that will wrap the dotnet executable.
This program will be compiled and used instead of directly calling the dotnet executable.""",
            default = Label("//csharp/private:wrappers/dotnet.cc"),
            allow_single_file = True,
        ),
        "dotnet": attr.label_list(
            doc = "The dotnet executable.",
            mandatory = True,
            allow_files = True,
        ),
        "args": attr.label_list(
            doc = """Extra arguments to use when invoking dotnet.
At most 2 extra arguments are supported.""",
            allow_files = False,
        ),
    },
)
