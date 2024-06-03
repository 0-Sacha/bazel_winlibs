""

package(default_visibility = ["//visibility:public"])


filegroup(
    name = "cpp",
    srcs = ["bin/clang-cpp%{extention}"],
)
filegroup(
    name = "cc",
    srcs = ["bin/clang%{extention}"],
)
filegroup(
    name = "cxx",
    srcs = ["bin/clang++%{extention}"],
)
filegroup(
    name = "as",
    srcs = ["bin/llvm-as%{extention}"],
)
filegroup(
    name = "ar",
    srcs = ["bin/llvm-ar%{extention}"],
)
filegroup(
    name = "ld",
    srcs = ["bin/lld%{extention}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/llvm-objcopy%{extention}"],
)
filegroup(
    name = "strip",
    srcs = ["bin/llvm-strip%{extention}"],
)

filegroup(
    name = "cov",
    srcs = ["bin/llvm-cov%{extention}"],
)

filegroup(
    name = "size",
    srcs = ["bin/llvm-size%{extention}"],
)
filegroup(
    name = "nm",
    srcs = ["bin/llvm-nm%{extention}"],
)
filegroup(
    name = "objdump",
    srcs = ["bin/llvm-objdump%{extention}"],
)
filegroup(
    name = "dwp",
    srcs = ["bin/llvm-dwp%{extention}"],
)

filegroup(
    name = "dbg",
    srcs = ["bin/lldb%{extention}"],
)


filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"]),
)

filegroup(
    name = "toolchain_includes",
    srcs = glob([
        "lib/clang/%{clang_version}/include/**",
        "x86_64-w64-mingw32/include/**",
        "include/**",
    ]),
)

filegroup(
    name = "toolchain_libs",
    srcs = glob([
        "x86_64-w64-mingw32/lib/*",
        "lib/*",
    ]),
)

filegroup(
    name = "toolchain_bins",
    srcs = glob([
        "x86_64-w64-mingw32/bin/*%{extention}",
        "bin/*%{extention}",
    ]),
)


filegroup(
    name = "all_files",
    srcs = [
        ":toolchain_includes",
        ":toolchain_libs",
        ":toolchain_bins",
    ],
)

filegroup(
    name = "compiler_files",
    srcs = [
        ":toolchain_includes",
        ":cpp",
        ":cc",
        ":cxx",
    ],
)

filegroup(
    name = "linker_files",
    srcs = [
        ":toolchain_libs",
        ":cc",
        ":cxx",
        ":ld",
        ":ar",
    ],
)

filegroup(
    name = "coverage_files",
    srcs = [
        ":toolchain_includes",
        ":toolchain_libs",
        ":cc",
        ":cxx",
        ":ld",
        ":cov",
    ],
)

filegroup(
    name = "compiler_components",
    srcs = [
        ":cpp",
        ":cc",
        ":cxx",
        ":ar",
        ":ld",

        ":objcopy",
        ":strip",

        ":cov",

        ":nm",
        ":objdump",
        ":as",
        ":size",
        ":dwp",
        
        ":dbg",
    ],
)