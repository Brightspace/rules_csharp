load("//csharp/private:providers.bzl", "CSharpAssembly")
load("//csharp/private:rules/imports.bzl", "import_library", "import_multiframework_library")

# We don't support compiling new DLLs against the frameworks listed in the keys
# of this dict, but it's just fine to link against them. The values are the
# closest framework to the quasi-supported framework.
QUASI_SUPPORTED_TFMS = {
    "net11": "net20",
    "net35": "net40",
    "net403": "net45",
}

def _import_dll(dll, has_pdb, imports):
    path = dll.split("/")

    tfm = path[1]
    real_tfm = tfm
    quasi_supported = False

    if tfm in QUASI_SUPPORTED_TFMS.keys():
        tfm = QUASI_SUPPORTED_TFMS[tfm]
        quasi_supported = True
    elif tfm not in CSharpAssembly:
        # Ignore any other frameworks (e.g. PCLs)
        return

    lib_name = path[-1].rsplit(".", 1)[0]

    # The target name always has the real tfm in it
    target_name = "%s-%s" % (lib_name, real_tfm)

    if lib_name not in imports:
        imports[lib_name] = {tfm: target_name}
    elif quasi_supported and tfm in imports[lib_name]:
        # Don't bother with a quasi-supported framework if we also have a DLL for
        # its closest framework.
        return
    else:
        imports[lib_name][tfm] = target_name

    # if quasi_supported is true we might eventually overwrite
    # imports[lib_name][tfm] which means the import_library we're about to do
    # would go unreferenced. It's a private target though so it's not a big deal.

    if dll in has_pdb:
        import_library(
            name = target_name,
            target_framework = tfm,
            dll = dll,
            pdb = dll[:-3] + "pdb",
        )
    else:
        import_library(
            name = target_name,
            target_framework = tfm,
            dll = dll,
        )

def setup_basic_nuget_package():
    """This macro gets used to implement the default NuGet BUILD file.

       We are limited by the fact that Bazel does not allow the analysis phase to
       read the contents of source files, e.g. to correctly configure deps. For
       more advanced usages a BUILD file will need to be generated outside of
       Bazel. See docs/UsingNuGetPackages.md for more info.

       This has to be public so that packages can call it but you probably
       shouldn't use it directly.
    """
    dlls = native.glob(["lib/*/*.dll"])
    pdbs = native.glob(["lib/*/*.pdb"])

    has_pdb = { (pdb[:-3] + "dll"): 1 for pdb in pdbs }

    # Map from lib name to dict from tfm to target name
    imports = {}

    # Output import_library rules
    for dll in dlls:
        _import_dll(dll, has_pdb, imports)

    # Output import_multiframework_library rules
    for (name, tfms) in imports.items():
        import_multiframework_library(
            name = name,
            visibility = ["//visibility:public"],

            # I don't know how to do this better.
            netstandard = tfms.get("netstandard"),
            netstandard1_0 = tfms.get("netstandard1.0"),
            netstandard1_1 = tfms.get("netstandard1.1"),
            netstandard1_2 = tfms.get("netstandard1.2"),
            netstandard1_3 = tfms.get("netstandard1.3"),
            netstandard1_4 = tfms.get("netstandard1.4"),
            netstandard1_5 = tfms.get("netstandard1.5"),
            netstandard1_6 = tfms.get("netstandard1.6"),
            netstandard2_0 = tfms.get("netstandard2.0"),
            netstandard2_1 = tfms.get("netstandard2.1"),
            net20 = tfms.get("net20"),
            net40 = tfms.get("net40"),
            net45 = tfms.get("net45"),
            net451 = tfms.get("net451"),
            net452 = tfms.get("net452"),
            net46 = tfms.get("net46"),
            net461 = tfms.get("net461"),
            net462 = tfms.get("net462"),
            net47 = tfms.get("net47"),
            net471 = tfms.get("net471"),
            net472 = tfms.get("net472"),
            net48 = tfms.get("net48"),
            netcoreapp1_0 = tfms.get("netcoreapp1.0"),
            netcoreapp1_1 = tfms.get("netcoreapp1.1"),
            netcoreapp2_0 = tfms.get("netcoreapp2.0"),
            netcoreapp2_1 = tfms.get("netcoreapp2.1"),
            netcoreapp2_2 = tfms.get("netcoreapp2.2"),
            netcoreapp3_0 = tfms.get("netcoreapp3.0"),
        )
