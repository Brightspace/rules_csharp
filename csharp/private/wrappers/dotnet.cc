#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

#ifdef _WIN32
#include <direct.h>
#include <errno.h>
#include <process.h>
#include <windows.h>
#define getcwd _getcwd
#else  // not _WIN32
#include <stdlib.h>
#include <unistd.h>
#endif  // _WIN32
#include "tools/cpp/runfiles/runfiles.h"

using bazel::tools::cpp::runfiles::Runfiles;

std::string evprintf(std::string name, std::string path) {
  std::stringstream ss;
  ss << name << "=" << path;
  return ss.str();
}

bool copyFile(std::string source, std::string destination) {
  std::ifstream src(source, std::ios::binary);
  std::ofstream dest(destination, std::ios::binary);
  dest << src.rdbuf();
  return src && dest;
}

std::string resolveArgument(std::string argument,
                            std::map<std::string, std::string> subst) {
  for (const auto& kv : subst) {
    size_t pos = argument.find(kv.first);
    if (pos != std::string::npos)
      argument.replace(pos, kv.first.length(), kv.second);
  }

  return argument;
}

bool resolveParamsFile(std::string file,
                       std::map<std::string, std::string> subst) {
  std::ifstream in(file);
  std::ofstream paramsFile(file + ".bak");
  if (!in) {
    std::cerr << "Could not open " << file << std::endl;
    return false;
  }

  std::string line;
  while (std::getline(in, line)) {
    line = resolveArgument(line, subst);
    paramsFile << line << std::endl;

    // while (true) {
    //   size_t pos = line.find("__BAZEL_SOURCE_MAP__");
    //   if (pos != std::string::npos)
    //     line.replace(pos, target.length(), currentDir);
    //   else
    //     break;
    // }
  }

  paramsFile.close();
  in.close();
  return copyFile(file + ".bak", file);
}

std::string pwd() {
  char buffer[512];
  char* location = getcwd(buffer, sizeof(buffer));
  std::string result;
  if (location) {
    result = location;
  }

  return result;
}

int main(int argc, char** argv) {
  std::string error;

  auto runfiles = Runfiles::Create(argv[0], &error);

  if (runfiles == nullptr) {
    std::cerr << "Couldn't load runfiles: " << error << std::endl;
    return 101;
  }

  auto dotnet = runfiles->Rlocation("{DotnetExe}");
  if (dotnet.empty()) {
    std::cerr << "Couldn't find the .NET runtime" << std::endl;
    return 404;
  }

  // Get the name of the directory containing dotnet.exe
  auto dotnetDir = dotnet.substr(0, dotnet.find_last_of("/\\"));

  // dotnet requires these environment variables to be set.
  std::vector<std::string> envvars = {
      evprintf("HOME", dotnetDir),
      evprintf("DOTNET_CLI_HOME", dotnetDir),
      evprintf("APPDATA", dotnetDir),
      evprintf("PROGRAMFILES", dotnetDir),
      evprintf("USERPROFILE", dotnetDir),
      evprintf("DOTNET_CLI_TELEMETRY_OPTOUT", "1"),  // disable telemetry
  };

  // variable substitutions for parameters
  auto workspaceDir = pwd();
  std::map<std::string, std::string> substitutions = {
      {"__BAZEL_WORKSPACE__", "\\"},
      {"__BAZEL_SANDBOX__", workspaceDir},
  };

  for (int i = 1; i < argc; i++) {
    std::string argument = argv[i];
    argument = resolveArgument(argument, substitutions);
    if (argument[0] == '@') {
      resolveParamsFile(argument.substr(1), substitutions);
    }
  }

  // dotnet wants this to either be dotnet or dotnet.exe but doesn't have a
  // preference otherwise.
  auto dotnet_argv = new char*[argc + 1];
  dotnet_argv[0] = (char*)"dotnet";
  for (int i = 1; i < argc; i++) {
    dotnet_argv[i] = argv[i];
  }
  dotnet_argv[argc] = nullptr;

#ifdef _WIN32
  // _spawnve has a limit on the size of the environment variables
  // passed to the process. So here we will set the environment
  // variables for this process, and the spawned instance will inherit them
  for (int i = 1; i < envvars.size(); i++) {
    putenv(envvars[i].c_str());
  }

  // run `dotnet.exe` and wait for it to complete
  // the output from this cmd will be emitted to stdout
  auto result = _spawnv(_P_WAIT, dotnet.c_str(), dotnet_argv);
#else
  auto envc = envvars.size();
  auto envp = new char*[envc + 1];
  for (uint i = 0; i < envc; i++) {
    envp[i] = const_cast<char*>(&envvars[i][0]);
  }
  envp[envc] = nullptr;

  // run `dotnet.exe` and wait for it to complete
  // the output from this cmd will be emitted to stdout
  auto result = execve(dotnet.c_str(), const_cast<char**>(dotnet_argv), envp);
#endif  // _WIN32
  if (result != 0) {
    std::cout << "dotnet failed: " << errno << std::endl;
    return -1;
  }

  return result;
}