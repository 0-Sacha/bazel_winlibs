""

load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel-utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config")
load("//:artifacts_patterns.bzl", "MINGW_ATTIFACTS_PATTERNS")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config(
    name = "cc_toolchain_config_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    host_name = "%{host_name}",
    target_name = "%{target_name}",
    target_cpu = "%{target_cpu}",
    compiler = {
        "name": "gcc",
        "cc": "gcc",
        "cxx": "g++",
        "cov": "gcov",
    },
    toolchain_bins = "//:compiler_components",
    artifacts_patterns_packed = MINGW_ATTIFACTS_PATTERNS["%{host_name}"],
    flags = dicts.add(
        %{flags_packed},
        {
            "##linkcopts;copts":  "-no-canonical-prefixes;-fno-canonical-system-headers"
        }
    ),
    cxx_builtin_include_directories = [
        "%{toolchain_path_prefix}lib/gcc/x86_64-w64-mingw32/{gcc_version}/include",
        "%{toolchain_path_prefix}lib/gcc/x86_64-w64-mingw32/{gcc_version}/include-fixed",
        "%{toolchain_path_prefix}x86_64-w64-mingw32/include",
        "%{toolchain_path_prefix}include",
    ],

    copts = %{copts},
    conlyopts = %{conlyopts},
    cxxopts = %{cxxopts},
    linkopts = %{linkopts},
    defines = %{defines},
    includedirs = %{includedirs},
    linkdirs = [
        "%{toolchain_path_prefix}lib/gcc/x86_64-w64-mingw32/{gcc_version}",
        "%{toolchain_path_prefix}x86_64-w64-mingw32/lib",
    ] + %{linkdirs},
)

cc_toolchain(
    name = "cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    toolchain_config = ":cc_toolchain_config_%{toolchain_id}",
    
    all_files = "//:compiler_pieces",
    compiler_files = "//:compiler_files",
    linker_files = "//:linker_files",
    ar_files = "//:ar",
    as_files = "//:as",
    objcopy_files = "//:objcopy",
    strip_files = "//:strip",
    dwp_files = "//:dwp",
    coverage_files = "//:coverage_files",
    supports_param_files = 0
)

toolchain(
    name = "toolchain_%{toolchain_id}",
    toolchain = ":cc_toolchain_%{toolchain_id}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",

    target_compatible_with = %{target_compatible_with},
)


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
