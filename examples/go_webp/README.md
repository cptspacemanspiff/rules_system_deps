# Go WebP example

This example shows a tiny Go program built with Bazel that uses
[`github.com/kolesa-team/go-webp`](https://github.com/kolesa-team/go-webp).

## Prerequisites

- No system `libwebp` package is required.
- `libwebp` is fetched and built from source via `bazel_dep(name = "libwebp")`.

## Run

```bash
bazel run //:main
```

The program builds a small in-memory RGBA image, encodes it with libwebp, and
prints the encoded byte size.

Notes:

- `go-webp` hardcodes `#cgo LDFLAGS: -lwebp`.
- The Bazel `@libwebp//:libwebp` target is named `libwebp` but produces
  `liblibwebp.a`/`liblibwebp.so` outputs, so this example adds a small wrapper
  that provides a `libwebp.a` link name for cgo while still depending on the
  Bazel-built `@libwebp//:libwebp` target.
