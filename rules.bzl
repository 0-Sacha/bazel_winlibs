""

load("@bazel_mingw//:archives.bzl", "MINGW_ARCHIVES_REGISTRY")

def _mingw_impl(rctx):
    relative_path_prefix = "external/%s/" % rctx.name
    host_name = "{}_{}".format(rctx.os.name, rctx.os.arch)

    print("host_name {}".format(host_name))

    substitutions = {
        "%{host_name}": host_name,
    }
    rctx.template(
        "BUILD",
        Label("//templates:BUILD.tpl"),
        substitutions
    )
    rctx.template(
        "deps.bzl",
        Label("//templates:deps.bzl.tpl"),
        substitutions
    )

    archive = MINGW_ARCHIVES_REGISTRY[rctx.attr.version]["archives"][host_name]
    rctx.download_and_extract(archive["url"], sha256 = archive["sha256"], stripPrefix = archive["prefix"])

mingw_toolchain = repository_rule(
    attrs = {
        "version": attr.string(default = "latest"),
    },
    local = False,
    implementation = _mingw_impl,
)
