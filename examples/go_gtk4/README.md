# Go GTK4 example

This example shows a tiny Go program built with Bazel that uses
[`github.com/diamondburned/gotk4`](https://github.com/diamondburned/gotk4).

## Prerequisites

- `pkg-config`
- `gtk4` development package (for example `gtk4-devel` on Fedora, `libgtk-4-dev` on Debian/Ubuntu)

## Run

```bash
bazel run //:gazelle
bazel run //:main
```

This setup is intentionally simple and non-hermetic: cgo resolves `gtk4`
through the host system via `pkg-config`.

The app opens a small GTK4 window with a single label.
