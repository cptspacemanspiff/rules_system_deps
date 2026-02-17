"""Module extension for pkg_config repository rules."""

load("//private:pkg_config_repo.bzl", "pkg_config")

def _pkg_config_ext_impl(mctx):
    for mod in mctx.modules:
        for lib in mod.tags.lib:
            repo_name = lib.name
            target_name = lib.name
            print("pkg_config_ext: generating target @{}//:{} for pkg '{}'".format(repo_name, target_name, lib.pkg))
            pkg_config(name = repo_name, pkg = lib.pkg, target_name = target_name)

pkg_config_ext = module_extension(
    implementation = _pkg_config_ext_impl,
    tag_classes = {
        "lib": tag_class(attrs = {
            "name": attr.string(mandatory = True),
            "pkg": attr.string(mandatory = True),
        }),
    },
)
