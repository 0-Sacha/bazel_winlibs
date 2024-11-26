"""MinGW registry
"""

load("@bazel_utilities//toolchains:registry.bzl", "gen_archives_registry")

WINLIBS_14_2_0POSIX = {
    "toolchain": "MinGW",
    "version": "14.2.0posix",
    "version-short": "14.2",
    "latest": True,
    "details": { "gcc_version": "14.2.0", "clang_version": "19" },
    "archives": {
        "windows_x86_64": {
            "url": "https://github.com/brechtsanders/winlibs_mingw/releases/download/14.2.0posix-19.1.1-12.0.0-msvcrt-r2/winlibs-x86_64-posix-seh-gcc-14.2.0-llvm-19.1.1-mingw-w64msvcrt-12.0.0-r2.zip",
            "sha256": "D708DA35E888C3C78732C006CBC8A5AB0ECB33F9A6F6E7105FD29FFF56C642E8",
            "strip_prefix": "mingw64",
        }
    }
}

WINLIBS_13_2_0POSIX = {
    "toolchain": "MinGW",
    "version": "13.2.0posix",
    "version-short": "13.2",
    "latest": False,
    "details": { "gcc_version": "13.2.0", "clang_version": "17" },
    "archives": {
        "windows_x86_64": {
            "url": "https://github.com/brechtsanders/winlibs_mingw/releases/download/13.2.0posix-17.0.6-11.0.1-msvcrt-r5/winlibs-x86_64-posix-seh-gcc-13.2.0-llvm-17.0.6-mingw-w64msvcrt-11.0.1-r5.zip",
            "sha256": "15866EFC6A7AC0B5EEB5296FBFD1F51F96ACE823711512E73E8FE7871E564596",
            "strip_prefix": "mingw64",
        }
    }
}

WINLIBS_REGISTRY = gen_archives_registry([
    WINLIBS_13_2_0POSIX,
    WINLIBS_14_2_0POSIX
])