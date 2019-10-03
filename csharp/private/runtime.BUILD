exports_files(
    glob([
        "dotnet",
        "dotnet.exe",  # windows, yeesh
    ], allow_empty = True) +
    glob([
        "host/**/*",
        "shared/**/*",
    ]),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "everything",
    srcs = glob(["**/*"]),
    visibility = ["//visibility:public"],
)
