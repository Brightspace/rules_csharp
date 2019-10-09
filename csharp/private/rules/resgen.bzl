# Label of the template file to use.
_TEMPLATE = "@d2l_rules_csharp//csharp/private:rules/Template.csproj"
_TEMPLATE_EMBEDDED_RESOURCE = "        <EmbeddedResource Include=\"%s\" />"

def _csproj_embedded_resource(resx_files):
    result = ""
    for src in resx_files:
        result += _TEMPLATE_EMBEDDED_RESOURCE % (src.basename)
    return result

def _csharp_resx_impl(ctx):
    proj_name = ctx.file.csproj.basename[:-(len(ctx.file.csproj.extension)+1)]

    csproj_output = ctx.actions.declare_file(ctx.file.csproj.basename)
    embedded_resources = _csproj_embedded_resource(ctx.files.srcs)
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = csproj_output,
        substitutions = {
            "{FRAMEWORK}": ctx.attr.target_frameworks[0],
            "{RESOURCES}": embedded_resources,
        },
    )

    files = depset(direct = csproj_output)
    runfiles = ctx.runfiles(files = csproj_output)
    return [DefaultInfo(files = files, runfiles = runfiles)]

csharp_resx = rule(
    implementation = _csharp_resx_impl,
    attrs = {
        "srcs": attr.label_list(
            mandatory = True, 
            allow_files = True
        ),
        "csproj": attr.label(
            mandatory = True, 
            allow_single_file = True
        ),
        "target_frameworks": attr.string_list(
            doc = "A list of target framework monikers to build" +
                  "See https://docs.microsoft.com/en-us/dotnet/standard/frameworks",
            allow_empty = False,
        ),
        "_template": attr.label(
            default = Label(_TEMPLATE),
            allow_single_file = True,
        ),
    },
)
