"""
Actions for writing *.runtimeconfig.json files.
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
