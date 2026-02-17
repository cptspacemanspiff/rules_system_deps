"""Module extension for pkg_config repository rules."""

load("//private:pkg_config_repo.bzl", "pkg_config")
load("//private:go_pkg_config_repo.bzl", "go_pkg_config")

def _pkg_config_ext_impl(mctx):
    known_libs = {}

    for mod in mctx.modules:
        for lib in mod.tags.lib:
            repo_name = lib.name
            target_name = lib.name
            print("pkg_config_ext: generating target @{}//:{} for pkg '{}'".format(repo_name, target_name, lib.pkg))
            pkg_config(name = repo_name, pkg = lib.pkg, target_name = target_name)
            known_libs[lib.name] = True

    go_profile_specs = []
    for mod in mctx.modules:
        for profile in mod.tags.go_profile:
            for lib in profile.libs:
                if lib not in known_libs:
                    fail("pkg_config_ext.go_profile '{}' references unknown lib '{}'".format(profile.name, lib))
            go_profile_specs.append("{}|{}".format(profile.name, ",".join(profile.libs)))

    if go_profile_specs:
        go_pkg_config(
            name = "pkg_config_go",
            profile_specs = go_profile_specs,
        )

pkg_config_ext = module_extension(
    implementation = _pkg_config_ext_impl,
    tag_classes = {
        "lib": tag_class(attrs = {
            "name": attr.string(mandatory = True),
            "pkg": attr.string(mandatory = True),
        }),
        "go_profile": tag_class(attrs = {
            "name": attr.string(mandatory = True),
            "libs": attr.string_list(mandatory = True),
        }),
    },
)
