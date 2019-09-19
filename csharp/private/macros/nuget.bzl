load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _get_build_file_content(build_file, build_file_content):
    if build_file == None and build_file_content == None:
        return """
load("@d2l_rules_csharp//csharp:defs.bzl", "setup_basic_nuget_package")
setup_basic_nuget_package()
"""

    return build_file_content

def import_nuget_package(
        name,
        package = None,
        version = None,
        nuget_sources = None,
        url = None,
        urls = None,
        build_file = None,
        build_file_content = None,
        sha256 = None):
    """Import a NuGet package from a NuGet repository or a vendored .nupkg file

    Exactly one of either package, url or urls arguments must be provided.

    To download from a NuGet repository, specify the package and version
    arguments. nuget_sources can be optionally specified to use custom
    repositories, otherwise nuget.org will be used.

    Alternatively, the url (or urls) to a nuget package may be provided, using
    either http:, https:// or file:// schemes (as supported by http_archive).

    At most one of build_file or build_file_content may be provided. If neither
    are, a default BUILD file will be used that makes a "best effort" to wire
    up the package. See docs/UsingNuGetPacakges.md for more info.

    Args:
      name: A unique name for the package's workspace.
      package: A package name on NuGet. Must not be specified if url or urls
          is specified.
      version: A package version on NuGet.
      nuget_sources: A list of NuGet repositories.
      url: A URL to a nupkg file. See http_archive. Must not be specified if
          package or urls is specified.
      urls: A list of URLS to a nupkg file. See http_archive. Must no be
          specified if package or url is specified.
      build_file: The path to a BUILD file to use for the package.
      build_file_content: A string containing the contents of a BUILD file.
      sha256: The SHA256 of the package.
    """

    if len([arg for arg in [package, url, urls] if arg != None]) != 0:
        fail("One and only of of pacakge, url or urls must be provided.")

    if package == None and version != None:
        fail("version must be used with package.")

    if package == None and nuget_sources != None:
        fail("nuget_sources must be used with package.")

    if url != None:
        urls = [url]

    else if package != None:
        if version == None:
            fail("package must be used with version.")

        nuget_sources = nuget_sources or [
            "https://www.nuget.org/api/v2/package",
        ]

        urls = ["{}/{}/{}".format(s, package, version) for s in nuget_sources]


    build_file_content = _get_build_file_content(build_file, build_file_content)

    http_archive(
        name = name,
        urls = urls,
        type = "zip",
        sha256 = "sha256",
        build_file = build_file,
        build_file_content = build_file_content,
    )

def import_nuget_package_directory(
        name,
        path,
        build_file = None,
        build_file_content = None):
    """Import an extracted NuGet package from a local directory.

    At most one of build_file or build_file_content may be provided. If neither
    are, a default BUILD file will be used that makes a "best effort" to wire
    up the package. See docs/UsingNuGetPacakges.md for more info.

    Args:
        name: A unique name name for the package's workspace.
        path: A directory containing an extracted package.
        build_file: The path to a BUILD file to use for the package.
        build_file_content: A string containing the contents of a BUILD file.
    """

    build_file_content = _get_build_file_content(build_file, build_file_content)

    native.new_local_repository(
        name = name,
        build_file = build_file,
        build_file_content = build_file_content,
        path = dir,
    )
