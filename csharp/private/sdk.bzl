"""
Declarations for the .NET SDK Downloads URLs and version

These are the URLs to download the .NET SDKs for each of the supported operating systems. These URLs are accessible from: https://dotnet.microsoft.com/download/dotnet-core.
"""
DOTNET_SDK_VERSION = "5.0.100"
DOTNET_SDK = {
    "windows": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/7b78bdaa-d0ac-41c4-9fdc-5820d7dc79b6/cea499dd314ba6394ccea51a2a2dcda9/dotnet-sdk-5.0.100-win-x64.zip",
        "hash": "296c89fbfdfedb652e314342e0de069ff392db1a4b0367a2daa9554cf50c1dec",
    },
    "linux": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/820db713-c9a5-466e-b72a-16f2f5ed00e2/628aa2a75f6aa270e77f4a83b3742fb8/dotnet-sdk-5.0.100-linux-x64.tar.gz",
        "hash": "b8278fd20a7242e711ee46910c23804babf9b38a4c1b97e2a4d9c5155d21cbd2",
    },
    "osx": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/0871336f-9a83-4ce4-80ca-625d03003369/2eb78456e0b106e9515dc03898d3867a/dotnet-sdk-5.0.100-osx-x64.tar.gz",
        "hash": "cbe223333a9724e83bd1448db30a8b5136a46a3d1c1a1f42c26e31b01523a389",
    },
}

RUNTIME_TFM = "netcoreapp5.0"
RUNTIME_FRAMEWORK_VERSION = "5.0.100"
