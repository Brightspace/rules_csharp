"""
An action that generates code for the C++ dotnet wrapper.
"""

def write_wrapper_main_cc(ctx, name, template, dotnetexe, argv1 = None, argv2 = None):
    """Create the *.main.cc file which wraps dotnet.exe.

    Args:
      ctx: Rule context
      name: The name of the associated target for this actione
      template: The template .cc file
      dotnetexe: The File object for dotnet.exe
      argv1: (Optional) a value to inject as argv1
      argv2: (Optional) a value to inject as argv2

    Returns:
      A File object to be used in a cc_binary target.
    """

    main_cc = ctx.actions.declare_file("%s.main.cc" % name)

    # Trim leading "../"
    # e.g. ../netcore-sdk-osx/dotnet
    dotnetexe_path = dotnetexe.short_path[3:]

    ctx.actions.expand_template(
        template = template,
        output = main_cc,
        substitutions = {
            "{DotnetExe}": dotnetexe_path,
            "{Argv1}": argv1 or "",
            "{Argv2}": argv2 or "",
        },
    )

    return main_cc
