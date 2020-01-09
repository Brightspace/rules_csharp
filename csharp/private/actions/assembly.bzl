"""
Actions for compiling targets with C#.
"""

load(
    "//csharp/private:common.bzl",
    "collect_transitive_info",
    "get_analyzer_dll",
    "use_highentropyva",
)
load(
    "//csharp/private:providers.bzl",
    "CSharpAssemblyInfo",
    "GetFrameworkVersionInfo",
)

def _format_ref_arg(assembly):
    return "/r:" + assembly.path

def _format_analyzer_arg(analyzer):
    return "/analyzer:" + analyzer

def _format_additionalfile_arg(additionalfile):
    return "/additionalfile:" + additionalfile.path

def _format_resource_arg(resource):
    return "/resource:" + resource.path

def _format_define(symbol):
    return "/d:" + symbol

def _framework_preprocessor_symbols(tfm):
    """Gets the standard preprocessor symbols for the target framework.

    See https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/preprocessor-directives/preprocessor-if#remarks
    for the official list.
    """

    specific = tfm.upper().replace(".", "_")

    if tfm.startswith("netstandard"):
        return ["NETSTANDARD", specific]
    elif tfm.startswith("netcoreapp"):
        return ["NETCOREAPP", specific]
    else:
        return ["NETFRAMEWORK", specific]

def AssemblyAction(
        actions,
        name,
        additionalfiles,
        analyzers,
        debug,
        defines,
        deps,
        keyfile,
        langversion,
        resources,
        srcs,
        out,
        target,
        target_framework,
        toolchain,
        runtimeconfig = None):
    """Creates an action that runs the CSharp compiler with the specified inputs.

    This macro aims to match the [C# compiler](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/listed-alphabetically), with the inputs mapping to compiler options.

    Args:
        actions: Bazel module providing functions to create actions.
        name: A unique name for this target.
        additionalfiles: Names additional files that don't directly affect code generation but may be used by analyzers for producing errors or warnings.
        analyzers: The list of analyzers to run from this assembly.
        debug: Emits debugging information.
        defines: The list of conditional compilation symbols.
        deps: The list of other libraries to be linked in to the assembly.
        keyfile: Specifies a strong name key file of the assembly.
        langversion: Specify language version: Default, ISO-1, ISO-2, 3, 4, 5, 6, 7, 7.1, 7.2, 7.3, or Latest
        resources: The list of resouces to be embedded in the assembly.
        srcs: The list of source (.cs) files that are processed to create the assembly.
        out: Specifies the output file name.
        target: Specifies the format of the output file by using one of four options.
        target_framework: The target framework moniker for the assembly.
        toolchain: The toolchain that supply the C# compiler.
        runtimeconfig: The runtime configuration of the assembly.

    Returns:
        The compiled csharp artifacts.
    """

    out_file_name = name if out == "" else out
    out_dir = "bazelout/" + target_framework
    out_ext = "dll" if target == "library" else "exe"
    out_file = actions.declare_file("%s/%s.%s" % (out_dir, out_file_name, out_ext))
    refout = actions.declare_file("%s/%s.ref.%s" % (out_dir, out_file_name, out_ext))
    pdb = actions.declare_file("%s/%s.pdb" % (out_dir, out_file_name))

    # Our goal is to match msbuild as much as reasonable
    # https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/listed-alphabetically
    args = actions.args()
    args.add("/unsafe-")
    args.add("/checked-")
    args.add("/nostdlib+")  # mscorlib will get added due to our transitive deps
    args.add("/utf8output")
    args.add("/deterministic+")
    args.add("/filealign:512")

    args.add("/nologo")

    if use_highentropyva(target_framework):
        args.add("/highentropyva+")
    else:
        args.add("/highentropyva-")

    (ssv, lang_version) = GetFrameworkVersionInfo(target_framework)
    if ssv != None:
        args.add("/subsystemversion:" + ssv)

    args.add("/warn:0")  # TODO: this stuff ought to be configurable

    args.add("/target:" + target)
    args.add("/langversion:" + (langversion or lang_version))

    if debug:
        args.add("/debug+")
        args.add("/optimize-")
        args.add("/define:TRACE;DEBUG")
    else:
        args.add("/debug-")
        args.add("/optimize+")
        args.add("/define:TRACE;RELEASE")

    args.add("/debug:portable")

    # The full path of source is embedded into PDBs when compiled
    # To resolve this, we use pathmap to substitute in new paths
    # that ensure that these are deterministic
    #
    # The dotnet wrapper (dotnetw) provides pathing variables
    # that can be substituted into any arguments passed in
    # These are of the form: __BAZEL_{name}_

    # pathmap
    args.add("/pathmap:%s=%s" % ("__BAZEL_SANDBOX__", "__BAZEL_WORKSPACE__"))

    # outputs
    args.add("/out:" + out_file.path)
    args.add("/refout:" + refout.path)
    args.add("/pdb:" + pdb.path)

    # assembly references
    (refs, runfiles, native_dlls) = collect_transitive_info(deps, target_framework)
    args.add_all(refs, map_each = _format_ref_arg)

    # analyzers
    analyzer_assemblies = [get_analyzer_dll(a) for a in analyzers]

    args.add_all(analyzer_assemblies, map_each = _format_analyzer_arg)
    args.add_all(additionalfiles, map_each = _format_additionalfile_arg)

    # .cs files
    args.add_all([cs.path for cs in srcs])

    # resources
    args.add_all(resources, map_each = _format_resource_arg)

    # defines
    args.add_all(
        _framework_preprocessor_symbols(target_framework) + defines,
        map_each = _format_define,
    )

    # keyfile
    if keyfile != None:
        args.add("/keyfile:" + keyfile.path)

    # TODO:
    # - appconfig(?)
    # - define
    #   * Need to audit D2L defines
    #   * msbuild adds some by default depending on your TF; we should too
    # - doc (d2l can probably skip this?)
    # - main (probably not a high priority for d2l)
    # - pathmap (needed for deterministic pdbs across hosts): this will
    #   probably need to be done in a wrapper because of the difference between
    #   the analysis phase (when this code runs) and execution phase.
    # - various code signing args (not needed for d2l)
    # - COM-related args like /link
    # - allow warnings to be configured
    # - unsafe (not needed for d2l)
    # - win32 args like /win32icon

    # spill to a "response file" when the argument list gets too big (Bazel
    # makes that call based on limitations of the OS).
    args.set_param_file_format("multiline")

    # Our wrapper uses _spawnv to launch dotnet, and that has a command line limit
    # of 1024 bytes, so always use a param file.
    args.use_param_file("@%s", use_always = True)

    direct_inputs = srcs + resources + analyzer_assemblies + additionalfiles + [toolchain.compiler]
    direct_inputs += [keyfile] if keyfile else []

    # dotnet.exe csc.dll /noconfig <other csc args>
    # https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/command-line-building-with-csc-exe
    actions.run(
        mnemonic = "CSharpCompile",
        progress_message = "Compiling " + name,
        inputs = depset(
            direct = direct_inputs,
            transitive = [refs] + [native_dlls],
        ),
        outputs = [out_file, refout, pdb],
        executable = toolchain.runtime,
        arguments = [
            toolchain.compiler.path,

            # This can't go in the response file (if it does it won't be seen
            # until it's too late).
            "/noconfig",
            args,
        ],
    )

    return CSharpAssemblyInfo[target_framework](
        out = out_file,
        refout = refout,
        pdb = pdb,
        native_dlls = native_dlls,
        deps = deps,
        transitive_refs = refs,
        transitive_runfiles = runfiles,
        actual_tfm = target_framework,
        runtimeconfig = runtimeconfig,
    )
