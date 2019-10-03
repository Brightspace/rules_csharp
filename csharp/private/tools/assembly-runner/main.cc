#include <iostream>
#include <unistd.h>
#include "tools/cpp/runfiles/runfiles.h"

using bazel::tools::cpp::runfiles::Runfiles;

int main(int argc, char** argv) {
  std::string error;

  auto runfiles = Runfiles::Create(argv[0], &error);

  if (runfiles == nullptr) {
    std::cerr << "Couldn't load runfiles: " << error << std::endl;
    return 1;
  }

  auto dotnet = runfiles->Rlocation("{DotnetExe}");

  if (dotnet.empty() || access(dotnet.c_str(), F_OK) == -1) {
    std::cerr << "Couldn't find the .NET runtime" << std::endl;
    return 1;
  }

  auto exe = runfiles->Rlocation("{TargetExe}");

  if (exe.empty() || access(dotnet.c_str(), F_OK) == -1) {
    std::cerr << "Couldn't find the target .exe" << std::endl;
    return 1;
  }

  auto dotnet_argv = new char*[argc + 4];

  // dotnet wants this to either be dotnet or dotnet.exe but doesn't have a
  // preference otherwise.
  dotnet_argv[0] = (char*)"dotnet";
  dotnet_argv[1] = (char*)"--runtimeconfig";
  dotnet_argv[2] = (char*)"{RuntimeConfigJson}";

  dotnet_argv[3] = (char*)exe.c_str();

  // Copy other args starting at argv[1]
  for (int i = 1; i < argc; i++) {
    dotnet_argv[3+i] = argv[i];
  }

  dotnet_argv[argc + 1] = 0;

  return execv(dotnet.c_str(), dotnet_argv);
}
