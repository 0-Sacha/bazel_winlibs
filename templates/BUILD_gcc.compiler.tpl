""

package(default_visibility = ["//visibility:public"])


filegroup(
    name = "cpp",
    srcs = glob(["bin/cpp%{extention}"]),
)

filegroup(
    name = "cc",
    srcs = glob(["bin/gcc%{extention}"]),
)

filegroup(
    name = "cxx",
    srcs = glob(["bin/g++%{extention}"]),
)

filegroup(
    name = "cov",
    srcs = glob(["bin/gcov%{extention}"]),
)

filegroup(
    name = "ar",
    srcs = glob(["bin/ar%{extention}"]),
)

filegroup(
    name = "ld",
    srcs = glob(["bin/ld%{extention}"]),
)

filegroup(
    name = "nm",
    srcs = glob(["bin/nm%{extention}"]),
)

filegroup(
    name = "objcopy",
    srcs = glob(["bin/objcopy%{extention}"]),
)

filegroup(
    name = "objdump",
    srcs = glob(["bin/objdump%{extention}"]),
)

filegroup(
    name = "strip",
    srcs = glob(["bin/strip%{extention}"]),
)

filegroup(
    name = "as",
    srcs = glob(["bin/as%{extention}"]),
)

filegroup(
    name = "size",
    srcs = glob(["bin/size%{extention}"]),
)

filegroup(
    name = "dwp",
    srcs = glob([]),
)


filegroup(
    name = "compiler_includes",
    srcs = glob([
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include/**",
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include-fixed/**",
        "x86_64-w64-mingw32/include/**",
        "include/**",
    ]),
)

filegroup(
    name = "compiler_libs",
    srcs = glob([
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/*",
        "x86_64-w64-mingw32/lib/*",
        "lib/*",
    ]),
)

filegroup(
    name = "toolchains_bins",
    srcs = glob([
        "bin/**",
        "x86_64-w64-mingw32/bin/**",
    ]),
)

filegroup(
    name = "compiler_pieces",
    srcs = [
        ":compiler_includes",
        ":compiler_libs",
    ],
)

filegroup(
    name = "compiler_files",
    srcs = [
        ":compiler_pieces",
        ":cpp",
        ":cc",
        ":cxx",
    ],
)

filegroup(
    name = "linker_files",
    srcs = [
        ":compiler_pieces",
        ":cc",
        ":cxx",
        ":ld",
        ":ar",
    ],
)

filegroup(
    name = "coverage_files",
    srcs = [
        ":compiler_pieces",
        ":cc",
        ":cxx",
        ":cov",
        ":ld",
    ],
)

filegroup(
    name = "compiler_components",
    srcs = [
        "cc",
        "cxx",
        "cpp",
        "cov",
        "ar",
        "ld",
        "nm",
        "objcopy",
        "objdump",
        "strip",
        "as",
        "size",
    ],
)


filegroup(
    name = "dbg",
    srcs = glob(["bin/gdb%{extention}"]),
)

filegroup(
    name = "compiler_extras",
    srcs = [
        "dbg",
    ],
)
