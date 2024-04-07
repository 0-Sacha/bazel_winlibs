""
load("//:artifacts_patterns.bzl", "MINGW_ATTIFACTS_PATTERNS")
load("//:utilities_cc_toolchain_config.bzl", "cc_toolchain_config")

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
    },
    toolchain_bins = "//:compiler_components",
    artifacts_patterns_packed = MINGW_ATTIFACTS_PATTERNS["%{host_name}"],
    flags = {},
    cxx_builtin_include_directories = [
        "%{toolchain_path_prefix}include",
        "%{toolchain_path_prefix}x86_64-w64-mingw32/include",
        "%{toolchain_path_prefix}lib/clang/%{clang_version}/include",
    ],
    lib_directories = [
        "%{toolchain_path_prefix}x86_64-w64-mingw32/lib",
    ],
    toolchain_libs = [
        "pthread"
    ]
)

cc_toolchain(
    name = "cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    toolchain_config = "cc_toolchain_config_%{toolchain_id}",
    
    all_files = "//:all_files",
    ar_files = "//:ar",
    compiler_files = "//:compiler_files",
    dwp_files = "//:dwp",
    linker_files = "//:linker_files",
    objcopy_files = "//:objcopy",
    strip_files = "//:strip",
    supports_param_files = 0
)

toolchain(
    name = "toolchain_%{toolchain_id}",
    toolchain = "cc_toolchain_%{toolchain_id}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",

    target_compatible_with = json.decode("%{target_compatible_with_packed}"),
)

filegroup(
    name = "cc",
    srcs = glob(["bin/clang*"]),
)

filegroup(
    name = "cxx",
    srcs = glob(["bin/clang++*"]),
)

filegroup(
    name = "cpp",
    srcs = glob(["bin/clang-cpp*"]),
)

filegroup(
    name = "cov",
    srcs = glob(["bin/llvm-cov*"]),
)

filegroup(
    name = "ar",
    srcs = glob(["bin/llvm-ar*"]),
)

filegroup(
    name = "ld",
    srcs = glob(["bin/ld*"]),
)

filegroup(
    name = "nm",
    srcs = glob(["bin/llvm-nm*"]),
)

filegroup(
    name = "objcopy",
    srcs = glob(["bin/llvm-objcopy*"]),
)

filegroup(
    name = "objdump",
    srcs = glob(["bin/llvm-objdump*"]),
)

filegroup(
    name = "strip",
    srcs = glob(["bin/llvm-strip*"]),
)

filegroup(
    name = "as",
    srcs = glob(["bin/llvm-as*"]),
)

filegroup(
    name = "size",
    srcs = glob(["bin/llvm-size*"]),
)


filegroup(
    name = "compiler_pieces",
    srcs = glob([
        "**"
    ]),
)

filegroup(
    name = "dwp",
    srcs = glob([]),
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
    srcs = glob(["bin/lldb*"]),
)

filegroup(
    name = "compiler_extras",
    srcs = [
        "dbg",
    ],
)
