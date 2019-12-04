#include <algorithm>
#include <fstream>
#include <ios>
#include <iostream>
#include <sstream>
#include <stdio.h>
#include <string>

#ifdef _WIN32
#include <errno.h>
#include <process.h>
#include <windows.h>
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

std::string slurp(std::ifstream& in) {
  std::stringstream sstr;
  sstr << in.rdbuf();
  return sstr.str();
}

int main(int argc, char** argv) {
  std::string error;

  auto runfiles = Runfiles::Create(argv[0], &error);
  if (runfiles == nullptr) {
    std::cerr << "Couldn't load runfiles: " << error << std::endl;
    return 101;
  }

  // csproj template for building resx files
  std::cout << "resx ref: "
            << "{ResXFile}" << std::endl;
  auto resx = runfiles->Rlocation("{ResXFile}");
  if (resx.empty()) {
    std::cerr << "Couldn't find the resx file" << std::endl;
    return 404;
  }
  std::cout << "resx: " << resx << std::endl;

  auto template_out = std::string(argv[2]);
  std::cout << "Template: " << template_out << std::endl;

  auto templateDir = template_out.substr(template_out.find_last_of("/\\") + 1);
  size_t dirsUp = std::count(template_out.begin(), template_out.end(), '/');
  std::cout << "templateDir: " << templateDir << " : " << dirsUp << std::endl;
  auto resxTmp = resx.substr(resx.find_first_of("/\\") + 1);

  std::stringstream tsstr;
  for (size_t i = 1; i < dirsUp; i++) {
    tsstr << "../";
  }
  tsstr << resxTmp;
  auto adjustedResX = tsstr.str();
  std::cout << "adjustedResX: " << adjustedResX << std::endl;

  // bazel-out/k8-fastbuild/bin/resgen/Hello.Strings-template.csproj
  // bazel-out/host/bin/resgen/Hello.Strings-execv.runfiles/csharp_examples/resgen/Strings.resx
  // csproj template for building resx files
  std::cout << "csproj ref: "
            << "{CsProjTemplate}" << std::endl;
  auto csproj = runfiles->Rlocation("{CsProjTemplate}");
  if (csproj.empty()) {
    std::cerr << "Couldn't find the csproj file" << std::endl;
    return 404;
  }
  std::cout << "csproj: " << csproj << std::endl;

  std::cout << "dotnet ref: "
            << "{DotnetExe}" << std::endl;
  auto dotnet = runfiles->Rlocation("{DotnetExe}");
  if (dotnet.empty()) {
    std::cerr << "Couldn't find the .NET runtime" << std::endl;
    return 404;
  }
  std::cout << "dotnet: " << dotnet << std::endl;

  std::ifstream ifs(csproj.c_str());
  std::string contents = slurp(ifs);

  std::string netFramework = "{NetFramework}";
  std::string manifest = "{ResXManifest}";

  std::string t_fmwk = "BazelResXFramework";
  contents.replace(contents.find(t_fmwk, 0), t_fmwk.length(), netFramework);

  std::string t_file = "BazelResXFile";
#ifdef _WIN32
  contents.replace(contents.find(t_file, 0), t_file.length(), resx);
#else
  contents.replace(contents.find(t_file, 0), t_file.length(), adjustedResX);
#endif  // _WIN32

  std::string t_name = "BazelResXManifestResourceName";
  contents.replace(contents.find(t_name, 0), t_name.length(), manifest);

  std::ofstream csprojfile;
  csprojfile.open(template_out);
  csprojfile << contents;
  csprojfile.close();

#ifdef _WIN32
  auto result = _spawnv(_P_WAIT, dotnet.c_str(), argv);
#else
  auto result = execv(dotnet.c_str(), const_cast<char**>(argv));
#endif  // _WIN32
  if (result != 0) {
    std::cout << "dotnet failed: " << result << " errno: " << errno
              << std::endl;
    return -1;
  }

  return result;
}