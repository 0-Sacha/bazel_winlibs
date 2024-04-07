""

load("@bazel_mingw//:archives.bzl", "MINGW_ARCHIVES_REGISTRY")
load("@bazel_utilities//toolchains:hosts.bzl", "get_host_infos_from_rctx")

def _mingw_impl(rctx):
    host_os, host_cpu, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    target_name = rctx.attr.target_name if rctx.attr.target_name != "" else host_os
    target_cpu = rctx.attr.target_cpu if rctx.attr.target_name != "" else host_cpu

    registry = MINGW_ARCHIVES_REGISTRY[rctx.attr.mingw_version]

    compiler_version = MINGW_ARCHIVES_REGISTRY[rctx.attr.mingw_version]["details"]["{}_version".format(rctx.attr.compiler)]
    toolchain_id = "mingw_{}_{}".format(rctx.attr.compiler, compiler_version)

    constraints = []
    constraints += rctx.attr.target_compatible_with
    if rctx.attr.use_host_constraint:
        constraints += [
            "@platforms//os:{}".format(host_os),
            "@platforms//cpu:{}".format(host_cpu)
        ]

    substitutions = {
        "%{host_name}": host_name,
        "%{target_name}": target_name,
        "%{target_cpu}": target_cpu,
        "%{toolchain_path_prefix}": "external/{}/".format(rctx.name),
        
        "%{toolchain_id}": toolchain_id,
        "%{clang_version}": registry["details"]["clang_version"],
        "%{gcc_version}": registry["details"]["gcc_version"],
        
        "%{target_compatible_with_packed}": json.encode(constraints).replace("\"", "\\\""),
    }
    rctx.template(
        "BUILD",
        Label("//templates:BUILD_{}.tpl".format(rctx.attr.compiler)),
        substitutions
    )
    rctx.template(
        "artifacts_patterns.bzl",
        Label("//templates:artifacts_patterns.bzl.tpl"),
        substitutions
    )

    archive = registry["archives"][host_name]
    rctx.download_and_extract(archive["url"], sha256 = archive["sha256"], stripPrefix = archive["strip_prefix"])

_mingw_toolchain = repository_rule(
    attrs = {
        'mingw_version': attr.string(default = "latest"),
        'compiler': attr.string(mandatory = True),

        'target_name': attr.string(default = ""),
        'target_cpu': attr.string(default = ""),

        'use_host_constraint': attr.bool(default = False),
        'target_compatible_with': attr.string_list(default = []),
    },
    local = False,
    implementation = _mingw_impl,
)

def mingw_toolchain(name, compiler = "gcc", mingw_version = "latest"):
    ""
    _mingw_toolchain(
        name = name,
        mingw_version = mingw_version,
        compiler = compiler,
        use_host_constraint = True
    )

    compiler_version = MINGW_ARCHIVES_REGISTRY[mingw_version]["details"]["{}_version".format(compiler)]
    native.register_toolchains("@{}//:toolchain_mingw_{}_{}".format(name, compiler, compiler_version))
