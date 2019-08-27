load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def nuget_package(
        name,
        package,
        version,
        sha256 = None,
        build_file = None,
        build_file_content = None):
    urls = [s + "/" + package + "/" + version for s in [
        # TODO: allow this to be configured
        "https://www.nuget.org/api/v2/package",
    ]]

    http_archive(
        name = name,
        urls = urls,
        type = "zip",
        sha256 = sha256,
        build_file = build_file,
        build_file_content = build_file_content,
    )
