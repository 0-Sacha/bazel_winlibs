"""MinGW registry
"""

load("@bazel_utilities//toolchains:registry.bzl", "gen_archives_registry")

WINLIBS_13_2_0POSIX = {
    "toolchain": "MinGW",
    "version": "13.2.0posix",
    "version-short": "13.2",
    "latest": True,
    "details": { "gcc_version": "13.2.0", "clang_version": "17" },
    "archives": {
        "windows_x86_64": {
            "url": "https://github.com/brechtsanders/winlibs/releases/download/13.2.0posix-17.0.6-11.0.1-msvcrt-r5/winlibs-x86_64-posix-seh-gcc-13.2.0-llvm-17.0.6-mingw-w64msvcrt-11.0.1-r5.zip",
            "sha256": "15866EFC6A7AC0B5EEB5296FBFD1F51F96ACE823711512E73E8FE7871E564596",
            "strip_prefix": "mingw64",
        }
    }
}

WINLIBS_REGISTRY = gen_archives_registry([
    WINLIBS_13_2_0POSIX
])