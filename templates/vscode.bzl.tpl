""

load("@bazel_utilities//tools:vscode_utils.bzl", _vscode_task = "vscode_task", _vscode_launch = "vscode_launch", _vscode_project = "vscode_project")

def vscode_task(name, **kwargs):
    """Task setting config for .vscode files

    Args:
        name: The rule name
        **kwargs: All others vscode_task attributes
    """
    _vscode_task(
        name = name,
        **kwargs
    )

def vscode_launch(name, **kwargs):
    """Launch setting config for .vscode files

    Args:
        name: The rule name
        **kwargs: All others vscode_launch attributes
    """
    _vscode_launch(
        name = name,
        debugger = "@%{rctx_name}//:dbg",
        **kwargs
    )

def vscode_project(name, **kwargs):
    """VS project config for .vscode files

    Args:
        name: The rule name
        **kwargs: All others vscode_project attributes
    """
    _vscode_project(
        name = name,
        compiler = "@%{rctx_name}//:cxx",
        **kwargs
    )
