// Mandelbrot Set the Coding Challenge #21 by the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import math

const (
	xsize   = 256
	ysize   = 256
	maxiter = 100
)

struct App {
mut:
	gg        &gg.Context = 0
	draw_flag bool        = true
	cx        f64 = 0.0
	cy        f64 = 0.0
	viewport  f64 = 2.0
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	app.gg.begin()
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			mut a := f64(i) / f64(xsize) * app.viewport + app.cx - 0.5 * app.viewport
			mut b := f64(j) / f64(xsize) * app.viewport + app.cy - 0.5 * app.viewport

			ca := a
			cb := b

			mut n := 0
			for n < maxiter {
				aa := a * a - b * b
				bb := 2 * a * b
				a = aa + ca
				b = bb + cb
				if a + b > 16 {
					break
				}
				n++
			}

			mut col := gx.white
			if n != maxiter {
				col = gx.Color{
					r: byte(math.sqrt(f64(n) / maxiter) * 255)
					g: 0
					b: 0
				}
			}
			app.gg.draw_pixel(i, j, col)
		}
	}
	app.gg.end()
}

fn (mut app App) resize() {
	size := gg.window_size()
	// avoid calls when minimized
	if size.width < 2 && size.height < 2 {
		return
	}
}

fn on_event(e &gg.Event, mut app App) {
	match e.typ {
		.resized, .resumed {
			app.resize()
		}
		.iconified {
			app.draw_flag = false
		}
		.restored {
			app.draw_flag = true
			app.resize()
		}
		else {
			if e.typ == .key_down {
				match e.key_code {
					.i {
						on_init(mut app)
					}
					.k {
						app.cy -= 0.1 * app.viewport
					}
					.j {
						app.cy += 0.1 * app.viewport
					}
					.h {
						app.cx -= 0.1 * app.viewport
					}
					.l {
						app.cx += 0.1 * app.viewport
					}
					.m {
						app.viewport *= 0.9
					}
					.n {
						app.viewport *= 1.1
					}
					.q {
						println('Good bye.')
						app.gg.quit()
					}
					else {}
				}
			}
		}
	}
}

fn on_init(mut app App) {
	app.resize()
	app.cx = 0.0
	app.cy = 0.0
	app.viewport = 2.0
}

// is needed for easier diagnostics on windows
[console]
fn main() {
	println("Press 'q' to quit. Press 'i' to initialize, 'hjkl' to slide, 'nm' to zoom.")
	mut font_path := os.resource_abs_path(os.join_path('..', 'assets', 'fonts', 'RobotoMono-Regular.ttf'))
	$if android {
		font_path = 'fonts/RobotoMono-Regular.ttf'
	}

	mut app := &App{}

	app.gg = gg.new_context(
		width: xsize
		height: ysize
		window_title: 'Mandelbrot!'
		bg_color: gx.yellow
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
