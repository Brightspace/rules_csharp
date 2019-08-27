load(
    "@d2l_rules_csharp//csharp/private:common.bzl",
    "get_analyzer_dll",
    "get_transitive_compile_refs",
)

def _format_ref_arg(assembly):
    return "/r:" + assembly.path

def _format_analyzer_arg(analyzer):
    return "/analyzer:" + analyzer

def _format_additionalfile_arg(additionalfile):
    return "/additionalfile:" + additionalfile.path

def _format_resource_arg(resource):
    return "/resource:" + resource.path

def AssemblyAction(
        actions,
        name,
        additionalfiles,
        analyzers,
        debug,
        deps,
        extra_deps,
        langversion,
        resources,
        srcs,
        target,
        target_framework,
        toolchain):
    out = actions.declare_file(name + ".dll")
    refout = actions.declare_file(name + ".ref.dll")
    pdb = actions.declare_file(name + ".pdb")

    transitive_compile_refs = get_transitive_compile_refs(
        deps + extra_deps,
        target_framework,
    )

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
    args.add("/highentropyva")

    args.add("/warn:0")  # TODO: this stuff ought to be configurable

    args.add("/target:" + target)
    args.add("/langversion:" + langversion)

    if debug:
        args.add("/debug+")
        args.add("/optimize-")
    else:
        args.add("/optimize+")

        # TODO: .NET core projects use debug:portable. Investigate this, maybe move
        #       some of this into the toolchain later.
        args.add("/debug:pdbonly")

    # outputs
    args.add("/out:" + out.path)
    args.add("/refout:" + refout.path)
    args.add("/pdb:" + pdb.path)

    # assembly references
    args.add_all(
        transitive_compile_refs,
        map_each = _format_ref_arg,
    )

    analyzerInputs = [get_analyzer_dll(a) for a in analyzers]

    args.add_all(
        analyzerInputs,
        map_each = _format_analyzer_arg,
    )

    args.add_all(
        additionalfiles,
        map_each = _format_additionalfile_arg,
    )

    # .cs files
    args.add_all([cs.path for cs in srcs])

    # resources
    args.add_all(
        resources,
        map_each = _format_resource_arg,
    )

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
    args.use_param_file("@%s")

    # dotnet.exe csc.dll /noconfig <other csc args>
    # https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/command-line-building-with-csc-exe
    actions.run(
        mnemonic = "CSharpCompile",
        progress_message = "Compiling " + name,
        inputs = depset(
            direct = srcs + resources + analyzerInputs + additionalfiles +
                     [toolchain.compiler],
            transitive = [transitive_compile_refs],
        ),
        outputs = [out, refout, pdb],
        executable = toolchain.runtime,
        arguments = [
            toolchain.compiler.path,

            # This can't go in the response file (if it does it won't be seen
            # until it's too late).
            "/noconfig",
            args,
        ],
    )

    return target_framework(
        out = out,
        refout = refout,
        pdb = pdb,
        transitive_compile_refs = transitive_compile_refs,
    )
