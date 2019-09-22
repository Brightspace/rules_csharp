"""A rule that sets up the @net workspace.

local_repository doesn't work well because it takes a path that is either
absolute (yuck) or relative to our users WORKSPACE file. Instead we use a
custom workspace rule.
"""

def _create_net_workspace_impl(ctx):
  # The "trick" here is that repository rules each create a workspace (named by
  # their name attr). So when we create files with ctx it's inside that
  # workspace.

  ctx.file("WORKSPACE", "workspace(name = \"%s\")\n" % ctx.name)
  ctx.symlink(ctx.attr.build_file, "BUILD.bazel")

_create_net_workspace = repository_rule(
    _create_net_workspace_impl,
    doc = "Set up the @net workspace",
    attrs = {
        "build_file": attr.label(
            allow_single_file = True,
            default = "@d2l_rules_csharp//csharp/private:net/BUILD",
        ),
    },
)

def create_net_workspace():
  """Create the @net workspace."""

  _create_net_workspace(name = "net")

