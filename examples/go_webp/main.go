package main

import (
	"bytes"
	"fmt"
	"image"
	"image/color"

	"github.com/kolesa-team/go-webp/encoder"
	"github.com/kolesa-team/go-webp/webp"
)

func main() {
	img := image.NewRGBA(image.Rect(0, 0, 64, 64))
	for y := 0; y < 64; y++ {
		for x := 0; x < 64; x++ {
			img.Set(x, y, color.RGBA{R: uint8(x * 4), G: uint8(y * 4), B: 120, A: 255})
		}
	}

	opts, err := encoder.NewLossyEncoderOptions(encoder.PresetDefault, 75)
	if err != nil {
		panic(err)
	}

	var out bytes.Buffer
	if err := webp.Encode(&out, img, opts); err != nil {
		panic(err)
	}

	fmt.Printf("encoded %d bytes of webp data\n", out.Len())
}
