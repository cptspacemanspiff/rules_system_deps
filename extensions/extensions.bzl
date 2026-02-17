"""Module extension for pkg_config repository rules."""

load("//private:pkg_config_repo.bzl", "pkg_config")
load("//private:go_pkg_config_repo.bzl", "go_pkg_config")

def _normalize_go_profile_dep(dep, known_libs, profile_name):
    if dep.startswith("@") or dep.startswith("//"):
        return dep
    if dep in known_libs:
        return "@{}//:{}".format(dep, dep)
    fail(
        "pkg_config_ext.go_profile '{}' dep '{}' is not a label and does not match a lib(name=...)".format(
            profile_name,
            dep,
        ),
    )

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
            deps = [_normalize_go_profile_dep(dep, known_libs, profile.name) for dep in profile.libs]
            go_profile_specs.append("{}|{}".format(profile.name, ",".join(deps)))

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
