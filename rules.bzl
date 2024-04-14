""

load("@bazel_mingw//:archives.bzl", "MINGW_ARCHIVES_REGISTRY")
load("@bazel_utilities//toolchains:hosts.bzl", "get_host_infos_from_rctx")

def _mingw_impl(rctx):
    _, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)

    registry = MINGW_ARCHIVES_REGISTRY[rctx.attr.mingw_version]

    compiler_version = MINGW_ARCHIVES_REGISTRY[rctx.attr.mingw_version]["details"]["{}_version".format(rctx.attr.compiler)]
    toolchain_id = "mingw_{}_{}".format(rctx.attr.compiler, compiler_version)

    target_compatible_with = []
    target_compatible_with += rctx.attr.target_compatible_with

    flags_packed = {}
    flags_packed.update(rctx.attr.flags_packed)

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{toolchain_path_prefix}": "external/{}/".format(rctx.name),
        "%{host_name}": host_name,
        "%{toolchain_id}": toolchain_id,
        "%{clang_version}": registry["details"]["clang_version"],
        "%{gcc_version}": registry["details"]["gcc_version"],
        
        "%{target_name}": rctx.attr.target_name,
        "%{target_cpu}": rctx.attr.target_cpu,
        "%{target_compatible_with}": json.encode(target_compatible_with),
        
        "%{copts}": json.encode(rctx.attr.copts),
        "%{conlyopts}": json.encode(rctx.attr.conlyopts),
        "%{cxxopts}": json.encode(rctx.attr.cxxopts),
        "%{linkopts}": json.encode(rctx.attr.linkopts),
        "%{defines}": json.encode(rctx.attr.defines),
        "%{includedirs}": json.encode(rctx.attr.includedirs),
        "%{linkdirs}": json.encode(rctx.attr.linkdirs),

        "%{flags_packed}": json.encode(flags_packed),
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
    rctx.template(
        "vscode.bzl",
        Label("//templates:vscode.bzl.tpl"),
        substitutions
    )

    archive = registry["archives"][host_name]
    rctx.download_and_extract(archive["url"], sha256 = archive["sha256"], stripPrefix = archive["strip_prefix"])

_mingw_toolchain = repository_rule(
    attrs = {
        'mingw_version': attr.string(default = "latest"),
        'compiler': attr.string(mandatory = True),

        'target_name': attr.string(default = "local"),
        'target_cpu': attr.string(default = ""),
        'target_compatible_with': attr.string_list(default = []),

        'copts': attr.string_list(default = []),
        'conlyopts': attr.string_list(default = []),
        'cxxopts': attr.string_list(default = []),
        'linkopts': attr.string_list(default = []),
        'defines': attr.string_list(default = []),
        'includedirs': attr.string_list(default = []),
        'linkdirs': attr.string_list(default = []),

        'flags_packed': attr.string_dict(default = {}),
    },
    local = False,
    implementation = _mingw_impl,
)

def mingw_toolchain(
        name,
        mingw_version = "latest",
        compiler = "gcc",

        target_name = "local",
        target_cpu = "",
        target_compatible_with = [],
        
        copts = [],
        conlyopts = [],
        cxxopts = [],
        linkopts = [],
        defines = [],
        includedirs = [],
        linkdirs = [],
        
        flags_packed = {},
    ):
    """MinGW Toolchain

    This macro create a repository containing all files needded to get an hermetic toolchain

    Args:
        name: Name of the repo that will be created
        mingw_version: The MinGW archive version
        compiler: The compiler to use: `gcc` or `clang` (default=`gcc`)

        target_name: The target name
        target_cpu: The target cpu name
        target_compatible_with: The target_compatible_with list for the toolchain

        copts: copts
        conlyopts: conlyopts
        cxxopts: cxxopts
        linkopts: linkopts
        defines: defines
        includedirs: includedirs
        linkdirs: linkdirs
        
        flags_packed: pack of flags, checkout the syntax at bazel_utilities
    """
    _mingw_toolchain(
        name = name,
        mingw_version = mingw_version,
        compiler = compiler,
        
        target_name = target_name,
        target_cpu = target_cpu,
        target_compatible_with = target_compatible_with,

        copts = copts,
        conlyopts = conlyopts,
        cxxopts = cxxopts,
        linkopts = linkopts,
        defines = defines,
        includedirs = includedirs,
        linkdirs = linkdirs,

        flags_packed = flags_packed,
    )

    compiler_version = MINGW_ARCHIVES_REGISTRY[mingw_version]["details"]["{}_version".format(compiler)]
    native.register_toolchains("@{}//:toolchain_mingw_{}_{}".format(name, compiler, compiler_version))
