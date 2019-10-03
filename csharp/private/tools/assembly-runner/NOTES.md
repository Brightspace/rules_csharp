```
$ bazel run eh world!
INFO: Analyzed target //csharp/private/tools/assembly-runner:eh (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //csharp/private/tools/assembly-runner:eh up-to-date:
  bazel-bin/csharp/private/tools/assembly-runner/eh
INFO: Elapsed time: 1.837s, Critical Path: 0.04s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
  It was not possible to find any installed .NET Core SDKs
  Did you mean to run .NET Core SDK commands? Install a .NET Core SDK from:
      https://aka.ms/dotnet-download
```

This matches what happens if I invoke dotnet manually. This is weird, I remember
this working when I was figuring out runtimeconfig.json...

Ran "sudo dtruss bazel run eh world!" on Mac (~strace) and it's definitely
looking for information about the SDK which is mostly unexpected. If I hack
main.cc to just send --list-runtimes it responds as expected (listing the
single runtime).

.NET Framework shouldn't wrap with dotnet.exe, but we probably still want the
C++ wrapper for that case to launch the assembly loader stuff that's up next.
