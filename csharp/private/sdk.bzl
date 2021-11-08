"""
Declarations for the .NET SDK Downloads URLs and version

These are the URLs to download the .NET SDKs for each of the supported operating systems. These URLs are accessible from: https://dotnet.microsoft.com/download/dotnet-core.
"""
DOTNET_SDK_VERSION = "6.0.100"
DOTNET_SDK = {
    "windows": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/ca65b248-9750-4c2d-89e6-ef27073d5e95/05c682ca5498bfabc95985a4c72ac635/dotnet-sdk-6.0.100-win-x64.zip",
        "hash": "21422989e10fb7ed46e639fc4eccef4b6d09eff842b3f517e80f5569567f4852",
    },
    "linux": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/17b6759f-1af0-41bc-ab12-209ba0377779/e8d02195dbf1434b940e0f05ae086453/dotnet-sdk-6.0.100-linux-x64.tar.gz",
        "hash": "8489a798fcd904a32411d64636e2747edf108192e0b65c6c3ccfb0d302da5ecb",
    },
    "osx": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/62f78047-71de-460e-85ca-254f1fa848de/ecabeefdca2902f3f06819612cd9d45c/dotnet-sdk-6.0.100-osx-x64.tar.gz",
        "hash": "6938e387b3e0c059683ef6ffb4c3ef726189ea88134462666cd6e346ad41294a",
    },
}

RUNTIME_TFM = "net6.0"
RUNTIME_FRAMEWORK_VERSION = "6.0.0"
