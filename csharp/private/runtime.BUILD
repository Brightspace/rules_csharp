exports_files(
    glob([
        "dotnet",
        "dotnet.exe",  # windows, yeesh
    ], allow_empty = True) +
    glob([
        "host/**/*",
        "shared/**/*",
    ]) +
    # csharp compiler: csc
    glob([
        "sdk/3.0.100/Roslyn/bincore/**/*",
    ]),
    visibility = ["//visibility:public"],
)
