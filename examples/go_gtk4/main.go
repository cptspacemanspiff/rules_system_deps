package main

import (
	"os"

	"github.com/diamondburned/gotk4/pkg/gtk/v4"
)

func main() {
	app := gtk.NewApplication("com.example.bazelgtk4", 0)
	app.ConnectActivate(func() {
		window := gtk.NewApplicationWindow(app)
		window.SetTitle("Bazel GTK4 Example")
		window.SetDefaultSize(420, 120)
		window.SetChild(gtk.NewLabel("Hello from Go + GTK4 + Bazel"))
		window.Present()
	})

	os.Exit(app.Run(os.Args))
}
