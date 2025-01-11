""

load("@bazel_skylib//lib:sets.bzl", "sets")
load("@bazel_utilities//toolchains:extras_filegroups.bzl", "filegroup_translate_to_starlark")
load("@bazel_utilities//toolchains:hosts.bzl", "get_host_infos_from_rctx", "split_host_name")
load("@bazel_utilities//toolchains:registry.bzl", "get_archive_from_registry")
load("@bazel_winlibs//:registry.bzl", "WINLIBS_REGISTRY")

def _winlibs_compiler_archive_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    if rctx.attr.override_host_name != "" and rctx.attr.override_host_name != "local":
        host_os, _, host_name = split_host_name(rctx.attr.override_host_name)
    
    registry = json.decode(rctx.attr.registry_json)
    archive = get_archive_from_registry(registry, "MinGW", rctx.attr.winlibs_version)

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{rctx_path}": "external/{}/".format(rctx.name),
        "%{host_name}": host_name,
        "%{clang_version}": archive["details"]["clang_version"],
        "%{gcc_version}": archive["details"]["gcc_version"],
    }
    rctx.template(
        "BUILD.bazel",
        Label("//templates:BUILD.compiler.bazel.tpl"),
        substitutions
    )

    host_archive = archive["archives"][host_name]
    rctx.download_and_extract(
        url = host_archive["url"],
        sha256 = host_archive["sha256"],
        stripPrefix = host_archive["strip_prefix"],
    )

winlibs_compiler_archive = repository_rule(
    implementation = _winlibs_compiler_archive_impl,
    attrs = {
        'override_host_name': attr.string(default = "local"),

        'winlibs_version': attr.string(default = "latest"),
        'registry_json': attr.string(mandatory = True),
    },
)


def _winlibs_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    if rctx.attr.override_host_name != "" and rctx.attr.override_host_name != "local":
        host_os, _, host_name = split_host_name(rctx.attr.override_host_name)

    registry = json.decode(rctx.attr.registry_json)
    archive = get_archive_from_registry(registry, "MinGW", rctx.attr.winlibs_version)

    toolchain_path = "external/{}/".format(rctx.name)
    compiler_package = ""
    compiler_full_package = "@@{}//".format(rctx.name)
    compiler_package_path = toolchain_path
    if rctx.attr.compiler_archive_package != None and rctx.attr.compiler_archive_package != "":
        compiler_package = "@@{}//".format(rctx.attr.compiler_archive_package.repo_name)
        compiler_full_package = compiler_package
        compiler_package_path = rctx.attr.compiler_archive_package.workspace_root + "/"

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{toolchain_path}": toolchain_path,
        "%{host_name}": host_name,
        "%{toolchain_id}": "winlibs_{}".format(rctx.attr.winlibs_version),
        "%{clang_version}": archive["details"]["clang_version"],
        "%{gcc_version}": archive["details"]["gcc_version"],
        "%{compiler_package}": compiler_package,
        "%{compiler_full_package}": compiler_full_package,
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
        "%{linklibs}": json.encode(rctx.attr.linklibs),
        # dbg / opt
        "%{dbg_copts}": json.encode(rctx.attr.dbg_copts),
        "%{dbg_linkopts}": json.encode(rctx.attr.dbg_linkopts),
        "%{opt_copts}": json.encode(rctx.attr.opt_copts),
        "%{opt_linkopts}": json.encode(rctx.attr.opt_linkopts),
        
        "%{toolchain_extras_filegroups}": json.encode(filegroup_translate_to_starlark(rctx.attr.toolchain_extras_filegroups), ),
    }
    rctx.template(
        "BUILD.bazel",
        Label("//templates:BUILD.bazel.tpl"),
        substitutions
    )
    rctx.template(
        "vscode.bzl",
        Label("//templates:vscode.bzl.tpl"),
        substitutions
    )

    if rctx.attr.compiler_archive_package == None or rctx.attr.compiler_archive_package == "":
        host_archive = archive["archives"][host_name]
        rctx.download_and_extract(
            url = host_archive["url"],
            sha256 = host_archive["sha256"],
            stripPrefix = host_archive["strip_prefix"],
        )

_winlibs_toolchain = repository_rule(
    implementation = _winlibs_impl,
    attrs = {
        'override_host_name': attr.string(default = "local"),

        'winlibs_version': attr.string(default = "latest"),
        'registry_json': attr.string(mandatory = True),

        'exec_compatible_with': attr.string_list(default = []),
        'target_compatible_with': attr.string_list(default = []),

        'copts': attr.string_list(default = []),
        'conlyopts': attr.string_list(default = []),
        'cxxopts': attr.string_list(default = []),
        'linkopts': attr.string_list(default = []),
        'defines': attr.string_list(default = []),
        'includedirs': attr.string_list(default = []),
        'linkdirs': attr.string_list(default = []),
        'linklibs': attr.string_list(default = []),
        # dbg / opt
        'dbg_copts': attr.string_list(default = []),
        'dbg_linkopts': attr.string_list(default = []),
        'opt_copts': attr.string_list(default = []),
        'opt_linkopts': attr.string_list(default = []),

        'toolchain_extras_filegroups': attr.label_list(default = []),

        'compiler_archive_package': attr.label(default = None),
    },
)

def winlibs_toolchain(
        name,
        winlibs_version = "latest",

        exec_compatible_with = [],
        target_compatible_with = [],
        
        copts = [],
        conlyopts = [],
        cxxopts = [],
        linkopts = [],
        defines = [],
        includedirs = [],
        linkdirs = [],
        linklibs = [],
        # dbg / opt
        dbg_copts = [],
        dbg_linkopts = [],
        opt_copts = [],
        opt_linkopts = [],

        toolchain_extras_filegroups = [],
        
        compiler_archive_package = None,
        registry = WINLIBS_REGISTRY,

        override_host_name = "local",
    ):
    """MinGW Toolchain

    This macro create a repository containing all files needded to get an hermetic toolchain

    Args:
        name: Name of the repo that will be created
        winlibs_version: The MinGW archive version

        exec_compatible_with: The exec_compatible_with list for the toolchain
        target_compatible_with: The target_compatible_with list for the toolchain

        copts: copts
        conlyopts: conlyopts
        cxxopts: cxxopts
        linkopts: linkopts
        defines: defines
        includedirs: includedirs
        linkdirs: linkdirs
        linklibs: linklibs
        # dbg / opt
        linklibs: linklibs
        dbg_copts: dbg_copts
        dbg_linkopts: dbg_linkopts
        opt_copts: opt_copts
        opt_linkopts: opt_linkopts

        toolchain_extras_filegroups: filegroup added to the cc_toolchain rule to get access to thoses files when sandboxed
        
        compiler_archive_package: The winlibs archive to use. If none are provided, one will be defined automatically
        registry: The arm registry to use, to allow close environement to provide their own mirroir/url

        override_host_name: override_host_name
    """
    if registry == None:
        registry = WINLIBS_REGISTRY

    _winlibs_toolchain(
        name = name,
        winlibs_version = winlibs_version,
        registry_json = json.encode(registry),

        exec_compatible_with = exec_compatible_with,
        target_compatible_with = target_compatible_with,

        copts = copts,
        conlyopts = conlyopts,
        cxxopts = cxxopts,
        linkopts = linkopts,
        defines = defines,
        includedirs = includedirs,
        linkdirs = linkdirs,
        linklibs = linklibs,
        # dbg / opt
        dbg_copts = dbg_copts,
        dbg_linkopts = dbg_linkopts,
        opt_copts = opt_copts,
        opt_linkopts = opt_linkopts,

        toolchain_extras_filegroups = toolchain_extras_filegroups,

        compiler_archive_package = compiler_archive_package,

        override_host_name = override_host_name,
    )


def _winlibs_toolchain_extension_impl(module_ctx):
    toolchain_versions_list = [
        (toolchain.override_host_name, toolchain.winlibs_version)
        for mod in module_ctx.modules 
        for toolchain in mod.tags.winlibs_toolchain
    ]
    if len(toolchain_versions_list) == 0:
        toolchain_versions_list.append(("local", "latest"))
    toolchain_versions_list = sets.to_list(sets.make(toolchain_versions_list))

    winlibs_registry = WINLIBS_REGISTRY
    for toolchains_version in toolchain_versions_list:
        winlibs_compiler_archive(
            name = "archive_winlibs-{}-{}".format(toolchains_version[0], toolchains_version[1]),
            winlibs_version = toolchains_version[1],
            registry_json = json.encode(winlibs_registry),
            override_host_name = toolchains_version[0],
        )
    
    for mod in module_ctx.modules:
        for toolchain in mod.tags.winlibs_toolchain:
            winlibs_toolchain(
                name = toolchain.name,
                winlibs_version = toolchain.winlibs_version,
                
                exec_compatible_with = toolchain.exec_compatible_with,
                target_compatible_with = toolchain.target_compatible_with,

                copts = toolchain.copts,
                conlyopts = toolchain.conlyopts,
                cxxopts = toolchain.cxxopts,
                linkopts = toolchain.linkopts,
                defines = toolchain.defines,
                includedirs = toolchain.includedirs,
                linkdirs = toolchain.linkdirs,
                linklibs = toolchain.linklibs,
                # dbg / opt
                dbg_copts = toolchain.dbg_copts,
                dbg_linkopts = toolchain.dbg_linkopts,
                opt_copts = toolchain.opt_copts,
                opt_linkopts = toolchain.opt_linkopts,

                toolchain_extras_filegroups = toolchain.toolchain_extras_filegroups,

                compiler_archive_package = "@archive_winlibs-{}-{}".format(toolchain.override_host_name, toolchain.winlibs_version),

                override_host_name = toolchain.override_host_name,
            )
    
winlibs_toolchain_extension = module_extension(
    implementation = _winlibs_toolchain_extension_impl,
    tag_classes = {
        "winlibs_toolchain": tag_class(attrs = {
            'override_host_name': attr.string(default = "local"),

            'name': attr.string(mandatory = True),
            'winlibs_version': attr.string(default = "latest"),

            'compiler_archive_package': attr.label(default = None),

            'exec_compatible_with': attr.string_list(default = []),
            'target_compatible_with': attr.string_list(default = []),

            'copts': attr.string_list(default = []),
            'conlyopts': attr.string_list(default = []),
            'cxxopts': attr.string_list(default = []),
            'linkopts': attr.string_list(default = []),
            'defines': attr.string_list(default = []),
            'includedirs': attr.string_list(default = []),
            'linkdirs': attr.string_list(default = []),
            'linklibs': attr.string_list(default = []),
            # dbg / opt
            'dbg_copts': attr.string_list(default = []),
            'dbg_linkopts': attr.string_list(default = []),
            'opt_copts': attr.string_list(default = []),
            'opt_linkopts': attr.string_list(default = []),

            'toolchain_extras_filegroups': attr.label_list(default = []),
        }),
    },
)
