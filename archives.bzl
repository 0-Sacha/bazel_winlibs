""

def _gen_archives_registry(archives_version):
    archives_registry = {}
    for archive_version in archives_version:
        archives_registry[archive_version["version"]] = archive_version
        if "version-short" in archive_version:
            archives_registry[archive_version["version-short"]] = archive_version
        if "latest" in archive_version and archive_version["latest"] == True:
            if "latest" in archives_registry:
                # buildifier: disable=print
                print("Registry Already Has an latest flagged archive. Ignoring...")
            else:
                archives_registry["latest"] = archive_version
    return archives_registry

MINGW_ARCHIVES_13_2_0POSIX = {
    "version": "13.2.0posix",
    "version-short": "13.2",
    "latest": True,
    "details": { "gcc_version": "13.2.0", "clang_version": "17" },
    "archives": {
        "windows_x86_64": {
            "sha256": "15866EFC6A7AC0B5EEB5296FBFD1F51F96ACE823711512E73E8FE7871E564596",
            "strip_prefix": "mingw64",
            "url": "https://github.com/brechtsanders/winlibs_mingw/releases/download/13.2.0posix-17.0.6-11.0.1-msvcrt-r5/winlibs-x86_64-posix-seh-gcc-13.2.0-llvm-17.0.6-mingw-w64msvcrt-11.0.1-r5.zip",
        }
    }
}

MINGW_ARCHIVES_REGISTRY = _gen_archives_registry([
    MINGW_ARCHIVES_13_2_0POSIX
])