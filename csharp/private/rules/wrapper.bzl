"""
A wrapper around `dotnet` for Bazel.
"""

load("//csharp/private:actions/wrapper.bzl", "write_wrapper_main_cc")

def _dotnet_wrapper_impl(ctx):
    cc_file = write_wrapper_main_cc(ctx, ctx.attr.name, ctx.file.template, ctx.files.src[0])

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
            default = Label("//csharp/private:wrappers/dotnet.cc"),
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
