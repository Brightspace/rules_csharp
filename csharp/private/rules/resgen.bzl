
def _csharp_resx_impl(ctx):
    print("todo")

csharp_resx = rule(
    implementation = _csharp_resx_impl,
    attrs = {
        "src": attr.label(
            doc = "The resx file."
            mandatory = True, 
            allow_single_file = True
        ),
        "identifier": attr.string(
            doc = "The identifier of the resource."
            mandatory = True, 
        ),
        "target_frameworks": attr.string_list(
            doc = "A list of target framework monikers to build.",
            allow_empty = False,
        ),
        "_csproj_template": attr.label(
            doc = "The csproj template used in compiling a resx file."
            default = Label(_TEMPLATE),
            allow_single_file = True,
        ),
        "_dotnet_runner": attr.string(
            doc = "Allows customizing the dotnet instance. [PH]"
            default = "dotnet",
        ),
    },
)
