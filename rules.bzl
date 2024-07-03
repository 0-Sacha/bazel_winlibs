""

load("@bazel_utilities//toolchains:hosts.bzl", "get_host_infos_from_rctx", "HOST_EXTENTION")
load("@bazel_utilities//toolchains:registry.bzl", "get_archive_from_registry")
load("@bazel_utilities//toolchains:utils.bzl", "forward_envars")
load("@bazel_winlibs_mingw//:registry.bzl", "WINLIBS_MINGW_REGISTRY")

def _winlibs_mingw_compiler_archive_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    
    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{rctx_path}": "external/{}/".format(rctx.name),
        "%{extention}": HOST_EXTENTION[host_os],
        "%{host_name}": host_name,
        "%{clang_version}": rctx.attr.clang_version,
        "%{gcc_version}": rctx.attr.gcc_version,
    }
    rctx.template(
        "BUILD",
        Label("//templates:BUILD_{}.compiler.tpl".format(rctx.attr.compiler)),
        substitutions
    )

    archives = json.decode(rctx.attr.archives)
    archive = archives[host_name]

    rctx.download_and_extract(
        url = archive["url"],
        sha256 = archive["sha256"],
        stripPrefix = archive["strip_prefix"],
    )

winlibs_mingw_compiler_archive = repository_rule(
    implementation = _winlibs_mingw_compiler_archive_impl,
    attrs = {
        'compiler': attr.string(mandatory = True),
        'clang_version': attr.string(mandatory = True),
        'gcc_version': attr.string(mandatory = True),
        'archives': attr.string(mandatory = True),
    },
    local = False,
)


def _winlibs_mingw_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)

    toolchain_id = ""
    if rctx.attr.compiler == "gcc":
        toolchain_id = "winlibs_mingw_{}_{}".format(rctx.attr.compiler, rctx.attr.gcc_version)
    elif rctx.attr.compiler == "clang":
        toolchain_id = "winlibs_mingw_{}_{}".format(rctx.attr.compiler, rctx.attr.clang_version)
    else:
        print("Compiler {} not supported by MinGW".format(rctx.attr.compiler)) # buildifier: disable=print
        
    toolchain_path = "external/{}/".format(rctx.name)
    compiler_package = ""
    compiler_package_path = toolchain_path
    if rctx.attr.local_download == False:
        compiler_package = "@{}//".format(rctx.attr.compiler_package_name)
        compiler_package_path = "external/{}/".format(rctx.attr.compiler_package_name)

    toolchain_extras_filegroup = "@{}//{}:{}".format(
        rctx.attr.toolchain_extras_filegroup.repo_name,
        rctx.attr.toolchain_extras_filegroup.package,
        rctx.attr.toolchain_extras_filegroup.name,
    )

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{extention}": HOST_EXTENTION[host_os],
        "%{toolchain_path}": toolchain_path,
        "%{host_name}": host_name,
        "%{toolchain_id}": toolchain_id,
        "%{clang_version}": rctx.attr.clang_version,
        "%{gcc_version}": rctx.attr.gcc_version,
        "%{compiler_package}": compiler_package,
        "%{compiler_package_path}": compiler_package_path,
        
        "%{exec_compatible_with}": json.encode(rctx.attr.exec_compatible_with),
        "%{target_compatible_with}": json.encode(rctx.attr.target_compatible_with),
        
        "%{copts}": json.encode(rctx.attr.copts),
        "%{conlyopts}": json.encode(rctx.attr.conlyopts),
        "%{cxxopts}": json.encode(rctx.attr.cxxopts),
        "%{linkopts}": json.encode(rctx.attr.linkopts),
        "%{defines}": json.encode(rctx.attr.defines),
        "%{includedirs}": json.encode(rctx.attr.includedirs),
        "%{linkdirs}": json.encode(rctx.attr.linkdirs),
        "%{toolchain_libs}": json.encode(rctx.attr.toolchain_libs),

        "%{toolchain_extras_filegroup}": toolchain_extras_filegroup,

        "%{envars}": json.encode(forward_envars(rctx)),
    }
    rctx.template(
        "BUILD",
        Label("//templates:BUILD_{}.tpl".format(rctx.attr.compiler)),
        substitutions
    )
    rctx.template(
        "vscode.bzl",
        Label("//templates:vscode.bzl.tpl"),
        substitutions
    )

    archives = json.decode(rctx.attr.archives)
    archive = archives[host_name]

    if rctx.attr.local_download:
        rctx.download_and_extract(
            url = archive["url"],
            sha256 = archive["sha256"],
            stripPrefix = archive["strip_prefix"],
        )

_winlibs_mingw_toolchain = repository_rule(
    attrs = {
        'winlibs_mingw_version': attr.string(default = "latest"),
        'compiler': attr.string(mandatory = True),
        'clang_version': attr.string(mandatory = True),
        'gcc_version': attr.string(mandatory = True),

        'local_download': attr.bool(default = True),
        'archives': attr.string(mandatory = True),
        'compiler_package_name': attr.string(mandatory = True),

        'exec_compatible_with': attr.string_list(default = []),
        'target_compatible_with': attr.string_list(default = []),

        'copts': attr.string_list(default = []),
        'conlyopts': attr.string_list(default = []),
        'cxxopts': attr.string_list(default = []),
        'linkopts': attr.string_list(default = []),
        'defines': attr.string_list(default = []),
        'includedirs': attr.string_list(default = []),
        'linkdirs': attr.string_list(default = []),
        'toolchain_libs': attr.string_list(default = []),

        'toolchain_extras_filegroup': attr.label(),
    },
    local = False,
    implementation = _winlibs_mingw_impl,
)

def winlibs_mingw_toolchain(
        name,
        winlibs_mingw_version = "latest",
        compiler = "gcc",

        exec_compatible_with = [],
        target_compatible_with = [],
        
        copts = [],
        conlyopts = [],
        cxxopts = [],
        linkopts = [],
        defines = [],
        includedirs = [],
        linkdirs = [],
        toolchain_libs = [],

        toolchain_extras_filegroup = "@bazel_utilities//:empty",
        
        local_download = True,
        registry = WINLIBS_MINGW_REGISTRY,

        auto_register_toolchain = True
    ):
    """MinGW Toolchain

    This macro create a repository containing all files needded to get an hermetic toolchain

    Args:
        name: Name of the repo that will be created
        winlibs_mingw_version: The MinGW archive version
        compiler: The compiler to use: `gcc` or `clang` (default=`gcc`)

        exec_compatible_with: The exec_compatible_with list for the toolchain
        target_compatible_with: The target_compatible_with list for the toolchain

        copts: copts
        conlyopts: conlyopts
        cxxopts: cxxopts
        linkopts: linkopts
        defines: defines
        includedirs: includedirs
        linkdirs: linkdirs
        toolchain_libs: toolchain_libs

        toolchain_extras_filegroup: filegroup added to the cc_toolchain rule to get access to thoses files when sandboxed
        
        local_download: wether the archive should be downloaded in the same repository (True) or in its own repo
        registry: The arm registry to use, to allow close environement to provide their own mirroir/url

        auto_register_toolchain: If the toolchain is registered to bazel using `register_toolchains`
    """
    compiler_package_name = ""

    archive = get_archive_from_registry(registry, "MinGW", winlibs_mingw_version)
    compiler_version = archive["details"]["{}_version".format(compiler)]

    if local_download == False:
        compiler_package_name = "archive_winlibs_mingw_{}_{}".format(compiler, compiler_version)
        winlibs_mingw_compiler_archive(
            name = compiler_package_name,
            compiler = compiler,
            clang_version = archive["details"]["clang_version"],
            gcc_version = archive["details"]["gcc_version"],
            archives = json.encode(archive["archives"]),
        )

    _winlibs_mingw_toolchain(
        name = name,
        winlibs_mingw_version = winlibs_mingw_version,
        compiler = compiler,
        clang_version = archive["details"]["clang_version"],
        gcc_version = archive["details"]["gcc_version"],

        local_download = local_download,
        archives = json.encode(archive["archives"]),
        compiler_package_name = compiler_package_name,

        exec_compatible_with = exec_compatible_with,
        target_compatible_with = target_compatible_with,

        copts = copts,
        conlyopts = conlyopts,
        cxxopts = cxxopts,
        linkopts = linkopts,
        defines = defines,
        includedirs = includedirs,
        linkdirs = linkdirs,
        toolchain_libs = toolchain_libs,

        toolchain_extras_filegroup = toolchain_extras_filegroup,
    )

    if auto_register_toolchain:
        compiler_version = archive["details"]["{}_version".format(compiler)]
        native.register_toolchains("@{}//:toolchain_winlibs_mingw_{}_{}".format(name, compiler, compiler_version))
