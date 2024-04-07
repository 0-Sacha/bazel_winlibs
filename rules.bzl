load("@bazel_mingw//:archives.bzl", "MINGW_ARCHIVES_REGISTRY")

def get_host_infos_from_rctx(os_name, os_arch):
    host_os = "linux"
    host_arch = "x86_64"

    if "windows" in os_name:
        host_os = "windows"
    elif "mac" in os_name:
        host_os = "osx"

    if "amd64" in os_arch:
        host_arch = "x86_64"
    elif "aarch64":
        host_arch = "arm64"

    return host_os, host_arch, "{}_{}".format(host_os, host_arch)

def _mingw_impl(rctx):
    host_os, host_cpu, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    registry = MINGW_ARCHIVES_REGISTRY[rctx.attr.version]

    target_compatible_with = rctx.attr.target_compatible_with
    if rctx.attr.use_host_constraint:
        target_compatible_with += [
            "@platforms//os:{}".format(host_os),
            "@platforms//cpu:{}".format(host_cpu)
        ]

    substitutions = {
        "%{toolchain_path_prefix}": "external/%s/" % rctx.name,
        "%{host_name}": host_name,
        
        "%{clang_id}": rctx.attr.clang_id,
        "%{gcc_id}": rctx.attr.gcc_id,
        "%{clang_version}": rctx.attr.clang_version,
        "%{gcc_version}": rctx.attr.gcc_version,
        
        "%{target_compatible_with}": json.encode(target_compatible_with),
    }
    rctx.template(
        "BUILD",
        Label("//templates:BUILD.tpl"),
        substitutions
    )

    rctx.template(
        "utilities_action_names.bzl",
        Label("//templates:utilities_action_names.bzl.tpl"),
        substitutions
    )
    rctx.template(
        "utilities_cc_toolchain_config.bzl",
        Label("//templates:utilities_cc_toolchain_config.bzl.tpl"),
        substitutions
    )
    rctx.template(
        "utilities_config.bzl",
        Label("//templates:utilities_config.bzl.tpl"),
        substitutions
    )
    rctx.template(
        "utilities_toolchain_config_feature_legacy.bzl",
        Label("//templates:utilities_toolchain_config_feature_legacy.bzl.tpl"),
        substitutions
    )

    archive = registry["archives"][host_name]
    rctx.download_and_extract(archive["url"], sha256 = archive["sha256"], stripPrefix = archive["strip_prefix"])

_mingw_toolchain = repository_rule(
    attrs = {
        'version': attr.string(default = "latest"),
        'gcc_id': attr.string(mandatory = True),
        'clang_id': attr.string(mandatory = True),
        'gcc_version': attr.string(mandatory = True),
        'clang_version': attr.string(mandatory = True),
        'use_host_constraint': attr.bool(default = False),
        'target_compatible_with': attr.string_list(default = []),
    },
    local = False,
    implementation = _mingw_impl,
)

def mingw_toolchain(name, version = "latest"):
    registry = MINGW_ARCHIVES_REGISTRY[version]
    gcc_id = "mingw_gcc_{}".format(registry["details"]["clang_version"])
    clang_id = "mingw_clang_{}".format(registry["details"]["clang_version"])

    _mingw_toolchain(
        name = name,
        version = version,
        gcc_id = gcc_id,
        gcc_version = registry["details"]["clang_version"],
        clang_id = clang_id,
        clang_version = registry["details"]["clang_version"],
    )

    native.register_toolchains("@{}//:toolchain_{}".format(name, clang_id))
