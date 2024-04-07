""

load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl", "tool_path", "action_config")

def _best_match(matchs):
    smallest = matchs[0]
    for match in matchs[1:]:
        if len(match.basename) < len(smallest.basename):
            smallest = match
    return smallest

def _get_tool_path(bins, tool_name, base_name = "", extention = ""):
    matchs = []
    tool_fullname = "{}{}{}".format(base_name, tool_name, extention)
    tool_fullname_woext = "{}{}".format(base_name, tool_name)
    for file in bins:
        if file.basename == tool_fullname:
            matchs.append(file)
        if file.basename.startswith(tool_fullname_woext):
            matchs.append(file)

    if len(matchs) == 0:
        # buildifier: disable=print
        print("Tool NOT Found : '{}' in {} !!".format(tool_fullname, bins))
        return None

    if len(matchs) == 1:
        return matchs[0]
    
    best = _best_match(matchs)
    # buildifier: disable=print
    print("Warrning: multiple Tool Found for {} !!. Keeping best : {}".format(tool_name, best))
    return best
    
def add_action_configs(toolchain_bins, tool_name, action_names, implies = []):
    action_configs = []
    for action_name in action_names:
        action_configs.append(
            action_config(
                action_name = action_name,
                tools = [ tool_path(name = tool_name, path = _get_tool_path(toolchain_bins, tool_name)) ],
                implies = implies
            )
        )
    return action_configs

def register_tools(tools):
    return [
        tool_path(name = name, path = path)
        for name, path in tools.items()
    ]
