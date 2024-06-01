"""
"""

load("@bazel_utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config")
load("@bazel_winlibs_mingw//:artifacts_patterns.bzl", "MINGW_ATTIFACTS_PATTERNS")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config(
    name = "cc_toolchain_config_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",

    compiler_type = "gcc",

    toolchain_bins = {
        "%{compiler_package}:cpp": "cpp",
        "%{compiler_package}:cc": "cc",
        "%{compiler_package}:cxx": "cxx",
        "%{compiler_package}:as": "as",
        "%{compiler_package}:ar": "ar",
        "%{compiler_package}:ld": "ld",

        "%{compiler_package}:objcopy": "objcopy",
        "%{compiler_package}:strip": "strip",

        "%{compiler_package}:cov": "cov",

        "%{compiler_package}:size": "size",
        "%{compiler_package}:nm": "nm",
        "%{compiler_package}:objdump": "objdump",
        "%{compiler_package}:dwp": "dwp",
        "%{compiler_package}:dbg": "dbg",
    },
    
    cxx_builtin_include_directories = [
        "%{compiler_package_path}lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include",
        "%{compiler_package_path}lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include-fixed",
        "%{compiler_package_path}x86_64-w64-mingw32/include",
        "%{compiler_package_path}include/c++/%{gcc_version}",
        "%{compiler_package_path}include/c++/%{gcc_version}/x86_64-w64-mingw32/bits/",
        "%{compiler_package_path}include/c++/%{gcc_version}/pstl",
        "%{compiler_package_path}include",
    ],

    copts = %{copts},
    conlyopts = %{conlyopts},
    cxxopts = %{cxxopts},
    linkopts = %{linkopts},
    defines = %{defines},
    includedirs = %{includedirs},
    linkdirs = [
        "%{compiler_package_path}lib/gcc/x86_64-w64-mingw32/%{gcc_version}",
        "%{compiler_package_path}x86_64-w64-mingw32/lib",
    ] + %{linkdirs},

    toolchain_libs = %{toolchain_libs},

    artifacts_patterns_packed = MINGW_ATTIFACTS_PATTERNS["%{host_name}"],
)

cc_toolchain(
    name = "cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    toolchain_config = ":cc_toolchain_config_%{toolchain_id}",
    
    all_files = "%{compiler_package}:all_files",
    compiler_files = "%{compiler_package}:compiler_files",
    linker_files = "%{compiler_package}:linker_files",
    ar_files = "%{compiler_package}:ar",
    as_files = "%{compiler_package}:as",
    
    objcopy_files = "%{compiler_package}:objcopy",
    strip_files = "%{compiler_package}:strip",
    
    coverage_files = "%{compiler_package}:coverage_files",
    
    dwp_files = "%{compiler_package}:dwp",

    # dynamic_runtime_lib
    # static_runtime_lib
    # supports_param_files
)

toolchain(
    name = "toolchain_%{toolchain_id}",
    toolchain = ":cc_toolchain_%{toolchain_id}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",

    exec_compatible_with = %{exec_compatible_with},
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
    name = "as",
    srcs = ["bin/as%{extention}"],
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
    name = "objcopy",
    srcs = ["bin/objcopy%{extention}"],
)
filegroup(
    name = "strip",
    srcs = ["bin/strip%{extention}"],
)

filegroup(
    name = "cov",
    srcs = ["bin/gcov%{extention}"],
)

filegroup(
    name = "size",
    srcs = ["bin/size%{extention}"],
)
filegroup(
    name = "nm",
    srcs = ["bin/nm%{extention}"],
)
filegroup(
    name = "objdump",
    srcs = ["bin/objdump%{extention}"],
)
filegroup(
    name = "dwp",
    srcs = ["bin/dwp%{extention}"],
)

filegroup(
    name = "dbg",
    srcs = ["bin/gdb%{extention}"],
)


filegroup(
    name = "toolchain_includes",
    srcs = glob([
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include/**",
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/include-fixed/**",
        "x86_64-w64-mingw32/include/**",
        "include/**",
    ]),
)

filegroup(
    name = "toolchain_libs",
    srcs = glob([
        "lib/gcc/x86_64-w64-mingw32/%{gcc_version}/*",
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