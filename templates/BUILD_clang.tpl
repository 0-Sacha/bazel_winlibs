""

load("@bazel_winlibs_mingw//:artifacts_patterns.bzl", "MINGW_ATTIFACTS_PATTERNS")
load("@bazel_utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config(
    name = "cc_toolchain_config_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    host_name = "%{host_name}",
    target_name = "%{target_name}",
    target_cpu = "%{target_cpu}",
    compiler = {
        "name": "clang",
        "cc": "clang",
        "cxx": "clang++",
        "cov": "llvm-cov",
        "ar": "llvm-ar",
        "strip": "llvm-strip",
        "size": "llvm-size",
        "nm": "llvm-nm",
        "as": "llvm-as",
        "objcopy": "llvm-objcopy",
        "objdump": "llvm-objdump",
        "ar": "llvm-ar",
        "strip": "llvm-strip",
        "size": "llvm-size",
        "nm": "llvm-nm",
        "as": "llvm-as",
        "objcopy": "llvm-objcopy",
        "objdump": "llvm-objdump",
    },
    toolchain_bins = "%{compiler_package}:compiler_components",
    artifacts_patterns_packed = MINGW_ATTIFACTS_PATTERNS["%{host_name}"],
    flags = %{flags_packed},
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
    
    toolchain_libs = [
        "pthread"
    ],
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

    exec_compatible_with = %{exec_compatible_with},
    target_compatible_with = %{target_compatible_with},
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
    name = "cov",
    srcs = ["bin/llvm-cov%{extention}"],
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
    name = "nm",
    srcs = ["bin/llvm-nm%{extention}"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/llvm-objcopy%{extention}"],
)

filegroup(
    name = "objdump",
    srcs = ["bin/llvm-objdump%{extention}"],
)

filegroup(
    name = "strip",
    srcs = ["bin/llvm-strip%{extention}"],
)

filegroup(
    name = "as",
    srcs = ["bin/llvm-as%{extention}"],
)

filegroup(
    name = "size",
    srcs = ["bin/llvm-size%{extention}"],
)

filegroup(
    name = "dwp",
    srcs = ["bin/llvm-dwp%{extention}"],
)


filegroup(
    name = "compiler_includes",
    srcs = glob([
        "lib/clang/%{clang_version}/include/**",
        "x86_64-w64-mingw32/include/**",
        "include/**",
    ]),
)

filegroup(
    name = "compiler_libs",
    srcs = glob([
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
    srcs = ["bin/lldb%{extention}"],
    srcs = ["bin/lldb%{extention}"],
)

filegroup(
    name = "compiler_extras",
    srcs = [
        "dbg",
    ],
)
