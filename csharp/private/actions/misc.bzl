"""
Actions for generating various files.
"""

load("//csharp/private:sdk.bzl", "RUNTIME_FRAMEWORK_VERSION", "RUNTIME_TFM")

def write_runtimeconfig(actions, template, name, tfm):
    """Create a *.runtimeconfig.json file.
    
    This file is necessary when running a .NET Core binary.

    Args:
      actions: An actions module, usually from ctx.actions.
      template: A template file.
      name: The name of the executable.
      tfm: The target framework moniker for the exe being built.
    """

    output = actions.declare_file("bazelout/%s/%s.runtimeconfig.json" % (tfm, name))

    # We're doing this as a template rather than a static file to allow users
    # to customize this if they wish.
    actions.expand_template(
        template = template,
        output = output,
        substitutions = {
            "{RUNTIME_TFM}": RUNTIME_TFM,
            "{RUNTIME_FRAMEWORK_VERSION}": RUNTIME_FRAMEWORK_VERSION,
        },
    )

    return output

def write_internals_visible_to(actions, name, others):
    """Write a .cs file containing InternalsVisibleTo attributes.

    Letting Bazel see which assemblies we are going to have InternalsVisibleTo
    allows for more robust caching of compiles.

    Args:
      actions: An actions module, usually from ctx.actions.
      name: The assembly name.
      others: The names of other assemblies.

    Returns:
      A File object for a generated .cs file
    """

    if len(others) == 0:
        return None

    attrs = actions.args()
    attrs.set_param_file_format(format = "multiline")

    attrs.add_all(
        others, 
        format_each = "[assembly: System.Runtime.CompilerServices.InternalsVisibleTo(\"%s\")]"
    )

    output = actions.declare_file("bazelout/%s/internalsvisibleto.cs" % name)

    actions.write(output, attrs)

    return output
