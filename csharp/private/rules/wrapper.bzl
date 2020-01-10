"""
A wrapper around `dotnet` for Bazel.
"""
_TEMPLATE = "//csharp/private:wrappers/dotnet.cc"

def _dotnet_wrapper_impl(ctx):
    cc_file = ctx.actions.declare_file("%s.cc" % (ctx.attr.name))
    if len(ctx.files.src) < 1:
        fail("No dotnet executable found in the SDK")

    ctx.actions.expand_template(
        template = ctx.file.template,
        output = cc_file,
        substitutions = {
            "{DotnetExe}": ctx.files.src[0].short_path[3:],
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
        "template": attr.label(
            doc = """Path to the program that will wrap the dotnet executable.
This program will be compiled and used instead of directly calling the dotnet executable.""",
            default = Label(_TEMPLATE),
            allow_single_file = True,
        ),
        "src": attr.label_list(
            doc = """The name of the dotnet executable.
On windows this should be 'dotnet.exe', and 'dotnet' on linux/macOS.""",
            mandatory = True,
            allow_files = True,
        ),
    },
)
