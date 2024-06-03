""

load("@bazel_utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config")
load("@bazel_winlibs_mingw//:artifacts_patterns.bzl", "MINGW_ATTIFACTS_PATTERNS")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config(
    name = "cc_toolchain_config_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",

    compiler_type = "clang",

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
        "%{compiler_package_path}include",
        "%{compiler_package_path}x86_64-w64-mingw32/include",
        "%{compiler_package_path}lib/clang/%{clang_version}/include",
    ],

    copts = %{copts},
    conlyopts = %{conlyopts},
    cxxopts = %{cxxopts},
    linkopts = %{linkopts},
    defines = %{defines},
    includedirs = %{includedirs},
    linkdirs = [
        "%{compiler_package_path}x86_64-w64-mingw32/lib",
    ] + %{linkdirs},
    
    toolchain_libs = %{toolchain_libs},

    artifacts_patterns_packed = MINGW_ATTIFACTS_PATTERNS["%{host_name}"],
)

cc_toolchain(
    name = "cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    toolchain_config = ":cc_toolchain_config_%{toolchain_id}",
    
    # TODO: Current fix for Sandboxed build # "%{compiler_package}:all_files",
    all_files = ":toolchain_every_files",
    compiler_files = ":toolchain_every_files",
    linker_files = ":toolchain_every_files",
    ar_files = ":toolchain_every_files",
    as_files = ":toolchain_every_files",
    objcopy_files = ":toolchain_every_files",
    strip_files = ":toolchain_every_files",
    dwp_files = ":toolchain_every_files",
    coverage_files = ":toolchain_every_files",

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
    name = "toolchain_every_files",
    srcs = [
        ":toolchain_internal_every_files",
        "%{toolchain_extras_filegroup}",
    ]
)


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