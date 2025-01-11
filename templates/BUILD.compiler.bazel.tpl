""

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"]),
)

#####################
####### clang #######
#####################

filegroup(
    name = "clang-cpp",
    srcs = ["bin/clang-cpp.exe"],
)
filegroup(
    name = "clang-cc",
    srcs = ["bin/clang.exe"],
)
filegroup(
    name = "clang-cxx",
    srcs = ["bin/clang++.exe"],
)
filegroup(
    name = "clang-as",
    srcs = ["bin/llvm-as.exe"],
)
filegroup(
    name = "clang-ar",
    srcs = ["bin/llvm-ar.exe"],
)
filegroup(
    name = "clang-ld",
    srcs = ["bin/lld.exe"],
)

filegroup(
    name = "clang-objcopy",
    srcs = ["bin/llvm-objcopy.exe"],
)
filegroup(
    name = "clang-strip",
    srcs = ["bin/llvm-strip.exe"],
)

filegroup(
    name = "clang-cov",
    srcs = ["bin/llvm-cov.exe"],
)

filegroup(
    name = "clang-size",
    srcs = ["bin/llvm-size.exe"],
)
filegroup(
    name = "clang-nm",
    srcs = ["bin/llvm-nm.exe"],
)
filegroup(
    name = "clang-objdump",
    srcs = ["bin/llvm-objdump.exe"],
)
filegroup(
    name = "clang-dwp",
    srcs = ["bin/llvm-dwp.exe"],
)

filegroup(
    name = "clang-dbg",
    srcs = ["bin/lldb.exe"],
)


filegroup(
    name = "clang-toolchain_includes",
    srcs = glob([
        "lib/clang/%{clang_version}/include/**",
        "x86_64-w64-mingw32/include/**",
        "include/**",
    ], allow_empty = True),
)

filegroup(
    name = "clang-toolchain_libs",
    srcs = glob([
        "x86_64-w64-mingw32/lib/*",
        "lib/*",
    ], allow_empty = True),
)

filegroup(
    name = "clang-toolchain_bins",
    srcs = glob([
        "x86_64-w64-mingw32/bin/*.exe",
        "bin/*.exe",
    ], allow_empty = True),
)


###################
####### gcc #######
###################

filegroup(
    name = "gcc-cpp",
    srcs = ["bin/cpp.exe"],
)
filegroup(
    name = "gcc-cc",
    srcs = ["bin/gcc.exe"],
)
filegroup(
    name = "gcc-cxx",
    srcs = ["bin/g++.exe"],
)
filegroup(
    name = "gcc-as",
    srcs = ["bin/as.exe"],
)
filegroup(
    name = "gcc-ar",
    srcs = ["bin/ar.exe"],
)
filegroup(
    name = "gcc-ld",
    srcs = ["bin/ld.exe"],
)

filegroup(
    name = "gcc-objcopy",
    srcs = ["bin/objcopy.exe"],
)
filegroup(
    name = "gcc-strip",
    srcs = ["bin/strip.exe"],
)

filegroup(
    name = "gcc-cov",
    srcs = ["bin/gcov.exe"],
)

filegroup(
    name = "gcc-size",
    srcs = ["bin/size.exe"],
)
filegroup(
    name = "gcc-nm",
    srcs = ["bin/nm.exe"],
)
filegroup(
    name = "gcc-objdump",
    srcs = ["bin/objdump.exe"],
)
filegroup(
    name = "gcc-dwp",
    srcs = ["bin/dwp.exe"],
)

filegroup(
    name = "gcc-dbg",
    srcs = ["bin/gdb.exe"],
)

filegroup(
    name = "gcc-toolchain_includes",
    srcs = glob([
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include/**",
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include-fixed/**",
        "x86_64-w64-mingw32/include/**",
        "include/**",
    ], allow_empty = True),
)

filegroup(
    name = "gcc-toolchain_libs",
    srcs = glob([
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/*",
        "x86_64-w64-mingw32/lib/*",
        "lib/*",
    ], allow_empty = True),
)

filegroup(
    name = "gcc-toolchain_bins",
    srcs = glob([
        "x86_64-w64-mingw32/bin/*.exe",
        "bin/*.exe",
    ], allow_empty = True),
)
