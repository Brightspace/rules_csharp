"""
Declarations for the .NET SDK Downloads URLs and version

These are the URLs to download the .NET SDKs for each of the supported operating systems. These URLs are accessible from: https://dotnet.microsoft.com/download/dotnet-core.
"""
DOTNET_SDK_VERSION = "5.0.104"
DOTNET_SDK = {
    "windows": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/00ca8180-e0e4-44c3-8e2c-16376071bc01/9c1af16773083a389366780b166693a1/dotnet-sdk-5.0.104-win-x64.zip",
        "hash": "e5bd8f9c3ef84df9fb639d880999bd19ec693be58b456b3c9983abec8948a5f3",
    },
    "linux": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/e0707d53-0310-4767-9db1-67ddc41f6fd8/38761ffd39860954aa7c8a54cbb025ca/dotnet-sdk-5.0.104-linux-x64.tar.gz",
        "hash": "ca41bcd52a80c9fe01be7c5dff47a2e0edbac71a9985d24ecaaf969103fd1951",
    },
    "osx": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/1dfb70ed-2f4a-40fb-a920-4a866440896c/0c4a206d58dc75417217883e8271a633/dotnet-sdk-5.0.104-osx-x64.tar.gz",
        "hash": "cf2a927fc61ef22e72a74a021c5352db21680550292ab879f93e63ce4a895fe4",
    },
}

RUNTIME_TFM = "netcoreapp5.0"
RUNTIME_FRAMEWORK_VERSION = "5.0.0"
