""

load("@bazel_winlibs_mingw//:artifacts_patterns.bzl", "MINGW_ATTIFACTS_PATTERNS")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config")

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
    toolchain_bins = "%{compiler_package}:compiler_components",
    artifacts_patterns_packed = MINGW_ATTIFACTS_PATTERNS["%{host_name}"],
    flags = dicts.add(
        %{flags_packed},
        {
            "##linkcopts,copts":  "-no-canonical-prefixes,-fno-canonical-system-headers"
        }
    ),
    cxx_builtin_include_directories = [
        "%{compiler_package_path}lib/gcc/x86_64-w64-mingw32/{gcc_version}/include",
        "%{compiler_package_path}lib/gcc/x86_64-w64-mingw32/{gcc_version}/include-fixed",
        "%{compiler_package_path}x86_64-w64-mingw32/include",
        "%{compiler_package_path}include",
    ],

    copts = %{copts},
    conlyopts = %{conlyopts},
    cxxopts = %{cxxopts},
    linkopts = %{linkopts},
    defines = %{defines},
    includedirs = %{includedirs},
    linkdirs = [
        "%{compiler_package_path}lib/gcc/x86_64-w64-mingw32/{gcc_version}",
        "%{compiler_package_path}x86_64-w64-mingw32/lib",
    ] + %{linkdirs},
)

cc_toolchain(
    name = "cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    toolchain_config = ":cc_toolchain_config_%{toolchain_id}",
    
    all_files = "%{compiler_package}:compiler_pieces",
    compiler_files = "%{compiler_package}:compiler_files",
    linker_files = "%{compiler_package}:linker_files",
    ar_files = "%{compiler_package}:ar",
    as_files = "%{compiler_package}:as",
    objcopy_files = "%{compiler_package}:objcopy",
    strip_files = "%{compiler_package}:strip",
    dwp_files = "%{compiler_package}:dwp",
    coverage_files = "%{compiler_package}:coverage_files",
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
    srcs = ["bin/gdb%{extention}"],
)

filegroup(
    name = "compiler_extras",
    srcs = [
        "dbg",
    ],
)
