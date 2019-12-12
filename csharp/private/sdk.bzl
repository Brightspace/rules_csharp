# buildifier: disable=module-docstring
# DotNET SDK Download URLs
# These are the URLs to download the .NET SDKs for each of the supported operating systems.
#
# You can get the latest URLs from here:
#   https://dotnet.microsoft.com/download/dotnet-core
DOTNET_SDK_VERSION = "3.1.100"
DOTNET_SDK = {
    "windows": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/28a2c4ff-6154-473b-bd51-c62c76171551/ea47eab2219f323596c039b3b679c3d6/dotnet-sdk-3.1.100-win-x64.zip",
        "hash": "abcd034b230365d9454459e271e118a851969d82516b1529ee0bfea07f7aae52",
    },
    "linux": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/d731f991-8e68-4c7c-8ea0-fad5605b077a/49497b5420eecbd905158d86d738af64/dotnet-sdk-3.1.100-linux-x64.tar.gz",
        "hash": "3687b2a150cd5fef6d60a4693b4166994f32499c507cd04f346b6dda38ecdc46",
    },
    "osx": {
        "url": "https://download.visualstudio.microsoft.com/download/pr/bea99127-a762-4f9e-aac8-542ad8aa9a94/afb5af074b879303b19c6069e9e8d75f/dotnet-sdk-3.1.100-osx-x64.tar.gz",
        "hash": "b38e6f8935d4b82b283d85c6b83cd24b5253730bab97e0e5e6f4c43e2b741aab",
    },
}
