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
    srcs = ["bin/clang-cpp%{extention}"],
)
filegroup(
    name = "clang-cc",
    srcs = ["bin/clang%{extention}"],
)
filegroup(
    name = "clang-cxx",
    srcs = ["bin/clang++%{extention}"],
)
filegroup(
    name = "clang-as",
    srcs = ["bin/llvm-as%{extention}"],
)
filegroup(
    name = "clang-ar",
    srcs = ["bin/llvm-ar%{extention}"],
)
filegroup(
    name = "clang-ld",
    srcs = ["bin/lld%{extention}"],
)

filegroup(
    name = "clang-objcopy",
    srcs = ["bin/llvm-objcopy%{extention}"],
)
filegroup(
    name = "clang-strip",
    srcs = ["bin/llvm-strip%{extention}"],
)

filegroup(
    name = "clang-cov",
    srcs = ["bin/llvm-cov%{extention}"],
)

filegroup(
    name = "clang-size",
    srcs = ["bin/llvm-size%{extention}"],
)
filegroup(
    name = "clang-nm",
    srcs = ["bin/llvm-nm%{extention}"],
)
filegroup(
    name = "clang-objdump",
    srcs = ["bin/llvm-objdump%{extention}"],
)
filegroup(
    name = "clang-dwp",
    srcs = ["bin/llvm-dwp%{extention}"],
)

filegroup(
    name = "clang-dbg",
    srcs = ["bin/lldb%{extention}"],
)


filegroup(
    name = "clang-toolchain_includes",
    srcs = glob([
        "lib/clang/%{clang_version}/include/**",
        "x86_64-w64-mingw32/include/**",
        "include/**",
    ]),
)

filegroup(
    name = "clang-toolchain_libs",
    srcs = glob([
        "x86_64-w64-mingw32/lib/*",
        "lib/*",
    ]),
)

filegroup(
    name = "clang-toolchain_bins",
    srcs = glob([
        "x86_64-w64-mingw32/bin/*%{extention}",
        "bin/*%{extention}",
    ]),
)


###################
####### gcc #######
###################

filegroup(
    name = "gcc-cpp",
    srcs = ["bin/cpp%{extention}"],
)
filegroup(
    name = "gcc-cc",
    srcs = ["bin/gcc%{extention}"],
)
filegroup(
    name = "gcc-cxx",
    srcs = ["bin/g++%{extention}"],
)
filegroup(
    name = "gcc-as",
    srcs = ["bin/as%{extention}"],
)
filegroup(
    name = "gcc-ar",
    srcs = ["bin/ar%{extention}"],
)
filegroup(
    name = "gcc-ld",
    srcs = ["bin/ld%{extention}"],
)

filegroup(
    name = "gcc-objcopy",
    srcs = ["bin/objcopy%{extention}"],
)
filegroup(
    name = "gcc-strip",
    srcs = ["bin/strip%{extention}"],
)

filegroup(
    name = "gcc-cov",
    srcs = ["bin/gcov%{extention}"],
)

filegroup(
    name = "gcc-size",
    srcs = ["bin/size%{extention}"],
)
filegroup(
    name = "gcc-nm",
    srcs = ["bin/nm%{extention}"],
)
filegroup(
    name = "gcc-objdump",
    srcs = ["bin/objdump%{extention}"],
)
filegroup(
    name = "gcc-dwp",
    srcs = ["bin/dwp%{extention}"],
)

filegroup(
    name = "gcc-dbg",
    srcs = ["bin/gdb%{extention}"],
)

filegroup(
    name = "gcc-toolchain_includes",
    srcs = glob([
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include/**",
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include-fixed/**",
        "x86_64-w64-mingw32/include/**",
        "include/**",
    ]),
)

filegroup(
    name = "gcc-toolchain_libs",
    srcs = glob([
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/*",
        "x86_64-w64-mingw32/lib/*",
        "lib/*",
    ]),
)

filegroup(
    name = "gcc-toolchain_bins",
    srcs = glob([
        "x86_64-w64-mingw32/bin/*%{extention}",
        "bin/*%{extention}",
    ]),
)
