""

package(default_visibility = ["//visibility:public"])


filegroup(
    name = "cpp",
    srcs = ["bin/cpp%{extention}"],
)

filegroup(
    name = "cc",
    srcs = ["bin/gcc%{extention}"],
)

filegroup(
    name = "cxx",
    srcs = ["bin/g++%{extention}"],
)

filegroup(
    name = "cov",
    srcs = ["bin/gcov%{extention}"],
)

filegroup(
    name = "ar",
    srcs = ["bin/ar%{extention}"],
)

filegroup(
    name = "ld",
    srcs = ["bin/ld%{extention}"],
)

filegroup(
    name = "nm",
    srcs = ["bin/nm%{extention}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/objcopy%{extention}"],
)

filegroup(
    name = "objdump",
    srcs = ["bin/objdump%{extention}"],
)

filegroup(
    name = "strip",
    srcs = ["bin/strip%{extention}"],
)

filegroup(
    name = "as",
    srcs = ["bin/as%{extention}"],
)

filegroup(
    name = "size",
    srcs = ["bin/size%{extention}"],
)

filegroup(
    name = "dwp",
    srcs = [],
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
        "x86_64-w64-mingw32/bin/*%{extention}",
        "bin/*%{extention}",
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
        ":cpp",
        ":cc",
        ":cxx",
        ":cov",
        ":ar",
        ":ld",
        ":nm",
        ":objcopy",
        ":objdump",
        ":strip",
        ":as",
        ":size",
        ":dwp",
    ],
)


filegroup(
    name = "dbg",
    srcs = ["bin/gdb%{extention}"],
)

filegroup(
    name = "compiler_extras",
    srcs = [
        "dbg",
    ],
)
