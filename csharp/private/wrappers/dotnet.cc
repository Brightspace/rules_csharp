#include <iostream>
#include <string>
#include <sstream>

#ifdef _WIN32
#include <fstream>
#include <windows.h>
#include <process.h>
#include <errno.h>
#else // not _WIN32
#include <stdlib.h>
#include <unistd.h>
#endif // _WIN32

#include "tools/cpp/runfiles/runfiles.h"

using bazel::tools::cpp::runfiles::Runfiles;

std::string evprintf(std::string name, std::string path)
{
  std::stringstream ss;
  ss << name << "=" << path;
  return ss.str();
}

int main(int argc, char **argv)
{
  std::string error;

  auto runfiles = Runfiles::Create(argv[0], &error);

  if (runfiles == nullptr)
  {
    std::cerr << "Couldn't load runfiles: " << error << std::endl;
    return 101;
  }

  auto dotnet = runfiles->Rlocation("{DotnetExe}");
  if (dotnet.empty())
  {
    std::cerr << "Couldn't find the .NET runtime" << std::endl;
    return 404;
  }

  // Get the name of the directory containing dotnet.exe
  auto dotnetDir = dotnet.substr(0, dotnet.find_last_of("/\\"));

  /*
  dotnet and nuget require these environment variables to be set
  without them we cannot build/run anything with dotnet.

  dotnet: HOME, DOTNET_CLI_HOME, APPDATA, PROGRAMFILES
  nuget: TMP, TEMP, USERPROFILE
  */
  std::vector<std::string> envvars;
  envvars.push_back(evprintf("HOME", dotnetDir));
  envvars.push_back(evprintf("DOTNET_CLI_HOME", dotnetDir));
  envvars.push_back(evprintf("APPDATA", dotnetDir));
  envvars.push_back(evprintf("PROGRAMFILES", dotnetDir));
  envvars.push_back(evprintf("USERPROFILE", dotnetDir));
  envvars.push_back(evprintf("DOTNET_CLI_TELEMETRY_OPTOUT", "1")); // disable telemetry

  // dotnet wants this to either be dotnet or dotnet.exe but doesn't have a
  // preference otherwise.
  auto dotnet_argv = new char *[argc];
  dotnet_argv[0] = (char *)"dotnet";
  for (int i = 1; i < argc; i++)
  {
    dotnet_argv[i] = argv[i];
  }
  dotnet_argv[argc] = 0;

  // run `dotnet.exe` and wait for it to complete
  // the output from this cmd will be emitted to stdout
#ifdef _WIN32
  for (int i = 1; i < envvars.size(); i++)
  {
    putenv(envvars[i].c_str());
  }
  auto result = _spawnv(_P_WAIT, dotnet.c_str(), dotnet_argv);
#else
  std::vector<char *> envp{};
  for (auto &envvar : envvars)
    envp.push_back(&envvar.front());
  envp.push_back(0);

  auto result = execve(dotnet.c_str(), dotnet_argv, envp.data());
#endif // _WIN32
  if (result != 0)
  {
    std::cout << "dotnet failed: " << errno << std::endl;
    return -1;
  }

  return result;
}