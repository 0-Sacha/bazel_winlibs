""

load("@bazel_utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config")
load("@bazel_winlibs//:artifacts_patterns.bzl", "WINLIBS_ATTIFACTS_PATTERNS")

package(default_visibility = ["//visibility:public"])


filegroup(
    name = "toolchain_every_files",
    srcs = [
        "%{compiler_package}:toolchain_internal_every_files",
    ] + %{toolchain_extras_filegroups}
)

filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"]),
)


#####################
####### clang #######
#####################

cc_toolchain_config(
    name = "clang-cc_toolchain_config_%{toolchain_id}",
    toolchain_identifier = "clang-%{toolchain_id}",

    compiler_type = "clang",

    toolchain_bins = {
        "%{compiler_package}:clang-cpp": "cpp",
        "%{compiler_package}:clang-cc": "cc",
        "%{compiler_package}:clang-cxx": "cxx",
        "%{compiler_package}:clang-as": "as",
        "%{compiler_package}:clang-ar": "ar",
        "%{compiler_package}:clang-ld": "ld",

        "%{compiler_package}:clang-objcopy": "objcopy",
        "%{compiler_package}:clang-strip": "strip",

        "%{compiler_package}:clang-cov": "cov",

        "%{compiler_package}:clang-size": "size",
        "%{compiler_package}:clang-nm": "nm",
        "%{compiler_package}:clang-objdump": "objdump",
        "%{compiler_package}:clang-dwp": "dwp",
        "%{compiler_package}:clang-dbg": "dbg",
    },

    toolchain_builtin_includedirs = [
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
    linklibs = %{linklibs},
    # dbg / opt
    dbg_copts = %{dbg_copts},
    dbg_linkopts = %{dbg_linkopts},
    opt_copts = %{opt_copts},
    opt_linkopts = %{opt_linkopts},

    artifacts_patterns_packed = WINLIBS_ATTIFACTS_PATTERNS["%{host_name}"],
)

cc_toolchain(
    name = "clang-cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "clang-%{toolchain_id}",
    toolchain_config = ":clang-cc_toolchain_config_%{toolchain_id}",
    
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
    name = "clang-toolchain",
    toolchain = ":clang-cc_toolchain_%{toolchain_id}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",

    exec_compatible_with = %{exec_compatible_with},
    target_compatible_with = %{target_compatible_with},
)


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


filegroup(
    name = "clang-all_files",
    srcs = [
        "%{compiler_package}:clang-toolchain_includes",
        "%{compiler_package}:clang-toolchain_libs",
        "%{compiler_package}:clang-toolchain_bins",
    ],
)

filegroup(
    name = "clang-compiler_files",
    srcs = [
        "%{compiler_package}:clang-toolchain_includes",
        "%{compiler_package}:clang-cpp",
        "%{compiler_package}:clang-cc",
        "%{compiler_package}:clang-cxx",
    ],
)

filegroup(
    name = "clang-linker_files",
    srcs = [
        "%{compiler_package}:clang-toolchain_libs",
        "%{compiler_package}:clang-cc",
        "%{compiler_package}:clang-cxx",
        "%{compiler_package}:clang-ld",
        "%{compiler_package}:clang-ar",
    ],
)

filegroup(
    name = "clang-coverage_files",
    srcs = [
        "%{compiler_package}:clang-toolchain_includes",
        "%{compiler_package}:clang-toolchain_libs",
        "%{compiler_package}:clang-cc",
        "%{compiler_package}:clang-cxx",
        "%{compiler_package}:clang-ld",
        "%{compiler_package}:clang-cov",
    ],
)

filegroup(
    name = "clang-compiler_components",
    srcs = [
        "%{compiler_package}:clang-cpp",
        "%{compiler_package}:clang-cc",
        "%{compiler_package}:clang-cxx",
        "%{compiler_package}:clang-ar",
        "%{compiler_package}:clang-ld",

        "%{compiler_package}:clang-objcopy",
        "%{compiler_package}:clang-strip",

        "%{compiler_package}:clang-cov",

        "%{compiler_package}:clang-nm",
        "%{compiler_package}:clang-objdump",
        "%{compiler_package}:clang-as",
        "%{compiler_package}:clang-size",
        "%{compiler_package}:clang-dwp",
        
        "%{compiler_package}:clang-dbg",
    ],
)


###################
####### gcc #######
###################

cc_toolchain_config(
    name = "gcc-cc_toolchain_config_%{toolchain_id}",
    toolchain_identifier = "gcc-%{toolchain_id}",

    compiler_type = "gcc",

    toolchain_bins = {
        "%{compiler_package}:gcc-cpp": "cpp",
        "%{compiler_package}:gcc-cc": "cc",
        "%{compiler_package}:gcc-cxx": "cxx",
        "%{compiler_package}:gcc-as": "as",
        "%{compiler_package}:gcc-ar": "ar",
        "%{compiler_package}:gcc-ld": "ld",

        "%{compiler_package}:gcc-objcopy": "objcopy",
        "%{compiler_package}:gcc-strip": "strip",

        "%{compiler_package}:gcc-cov": "cov",

        "%{compiler_package}:gcc-size": "size",
        "%{compiler_package}:gcc-nm": "nm",
        "%{compiler_package}:gcc-objdump": "objdump",
        "%{compiler_package}:gcc-dwp": "dwp",
        "%{compiler_package}:gcc-dbg": "dbg",
    },
    
    toolchain_builtin_includedirs = [
        "%{compiler_package_path}include/c++/%{gcc_version}",
        "%{compiler_package_path}include/c++/%{gcc_version}/x86_64-w64-mingw32/bits/",
        "%{compiler_package_path}include/c++/%{gcc_version}/pstl",
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

    linklibs = %{linklibs},

    artifacts_patterns_packed = WINLIBS_ATTIFACTS_PATTERNS["%{host_name}"],
)

cc_toolchain(
    name = "gcc-cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "gcc-%{toolchain_id}",
    toolchain_config = ":gcc-cc_toolchain_config_%{toolchain_id}",
    
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
    name = "gcc-toolchain",
    toolchain = ":gcc-cc_toolchain_%{toolchain_id}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",

    exec_compatible_with = %{exec_compatible_with},
    target_compatible_with = %{target_compatible_with},
)


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


filegroup(
    name = "gcc-all_files",
    srcs = [
        "%{compiler_package}:gcc-toolchain_includes",
        "%{compiler_package}:gcc-toolchain_libs",
        "%{compiler_package}:gcc-toolchain_bins",
    ],
)

filegroup(
    name = "gcc-compiler_files",
    srcs = [
        "%{compiler_package}:gcc-toolchain_includes",
        "%{compiler_package}:gcc-cpp",
        "%{compiler_package}:gcc-cc",
        "%{compiler_package}:gcc-cxx",
    ],
)

filegroup(
    name = "gcc-linker_files",
    srcs = [
        "%{compiler_package}:gcc-toolchain_libs",
        "%{compiler_package}:gcc-cc",
        "%{compiler_package}:gcc-cxx",
        "%{compiler_package}:gcc-ld",
        "%{compiler_package}:gcc-ar",
    ],
)

filegroup(
    name = "gcc-coverage_files",
    srcs = [
        "%{compiler_package}:gcc-toolchain_includes",
        "%{compiler_package}:gcc-toolchain_libs",
        "%{compiler_package}:gcc-cc",
        "%{compiler_package}:gcc-cxx",
        "%{compiler_package}:gcc-ld",
        "%{compiler_package}:gcc-cov",
    ],
)

filegroup(
    name = "gcc-compiler_components",
    srcs = [
        "%{compiler_package}:gcc-cpp",
        "%{compiler_package}:gcc-cc",
        "%{compiler_package}:gcc-cxx",
        "%{compiler_package}:gcc-ar",
        "%{compiler_package}:gcc-ld",

        "%{compiler_package}:gcc-objcopy",
        "%{compiler_package}:gcc-strip",

        "%{compiler_package}:gcc-cov",

        "%{compiler_package}:gcc-nm",
        "%{compiler_package}:gcc-objdump",
        "%{compiler_package}:gcc-as",
        "%{compiler_package}:gcc-size",
        "%{compiler_package}:gcc-dwp",
        
        "%{compiler_package}:gcc-dbg",
    ],
)
