"""
Declarations for the .NET SDK Downloads URLs and version

These are the URLs to download the .NET SDKs for each of the supported operating systems. These URLs are accessible from: https://dotnet.microsoft.com/download/dotnet-core.
"""
DOTNET_SDK_VERSION = "6.0.100-rc.2.21505.57"
DOTNET_SDK = {
    "windows": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/abbdf8c4-cf89-4d7c-972e-398aad2b56ac/b4c6204cc2c7e667e3fe72b6be090252/dotnet-sdk-6.0.100-rc.2.21505.57-win-x64.zip",
        "hash": "eb0f1cc60c6a44060acd06a66fc6605046e817483b1322cf85b081db71ffbff8",
    },
    "linux": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/20283373-1d83-4879-8278-0afb7fd4035e/56f204f174743b29a656499ad0fc93c3/dotnet-sdk-6.0.100-rc.2.21505.57-linux-x64.tar.gz",
        "hash": "506752857752512f199e97827c1e102656dc6490585758a93f37a792de2f9461",
    },
    "osx": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/35655ed6-3e37-4fa3-8990-5c1827469ce5/f9f920ff05b0aa5961a8b30e2824de7d/dotnet-sdk-6.0.100-rc.2.21505.57-osx-x64.tar.gz",
        "hash": "b42a7b378166bee735523f3ee656adbcc28ec6c0bc103ab1379e81a2fbd191f5",
    },
}

RUNTIME_TFM = "net6.0"
RUNTIME_FRAMEWORK_VERSION = "6.0.0"
