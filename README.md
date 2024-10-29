[![bazel_winlibs](https://github.com/0-Sacha/bazel_winlibs/actions/workflows/winlibs.yml/badge.svg)](https://github.com/0-Sacha/bazel_winlibs/actions/workflows/winlibs.yml)

# bazel_winlibs

A Bazel module that configures a MinGW toolchain for Windows, using the `winlibs standalone build` from [brechtsanders/winlibs_mingw](https://github.com/brechtsanders/winlibs_mingw).
This module allows Bazel to utilize the MinGW toolchain for building C++ projects on Windows.

## How to Use
MODULE.bazel
```python
winlibs_toolchain_extension = use_extension("@bazel_winlibs//:rules.bzl", "winlibs_toolchain_extension")
inject_repo(winlibs_toolchain_extension, "platforms", "bazel_utilities")
winlibs_toolchain_extension.winlibs_toolchain(
    name = "winlibs",
    copts = [],
)
use_repo(winlibs_toolchain_extension, "winlibs")
register_toolchains("@winlibs//:gcc-toolchain")
```
It provide two toolchains `@<repo>//:gcc-toolchain` / `@<repo>//:clang-toolchain`.
You can use these toolchains to compile any cc_rules in your project.

## Limitations
Currently, there is no support for sanitizers. The `--features=asan` flag will fail fail as the `-lasan` library is not found.
