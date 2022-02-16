// Conway's Game of Life, the Coding Challenge #85 by the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx

const (
	xsize  = 256 
	ysize  = 256 
	maxiter = 100
)

struct App {
mut:
	gen       int
	gg        &gg.Context = 0
	draw_flag bool        = true
	x1        f64 = -2.0
	y1        f64 = -1.5
	xzoom     f64 = 0.01
	yzoom     f64 = 0.01
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	app.gg.begin()
	for i in 0 .. xsize  {
		for j in 0 .. ysize {

			mut a := f64(i * app.xzoom) + app.x1
			mut b := f64(j * app.yzoom) + app.y1

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

			col := gx.Color{
				r: byte(n/maxiter*255)
				g: byte(n/maxiter*255)
				b: byte(n/maxiter*255)
			}
			app.gg.draw_pixel(i, j, col)
		}
	}
	app.gg.end()

	app.gen += 1

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
						println('Init')
						on_init(mut app)
					}
					.k {
						println('Up')
						app.y1 -= 0.1
					}
					.j {
						println('Down')
						app.y1 += 0.1
					}
					.h {
						println('left')
						app.x1 -= 0.1
					}
					.l {
						println('right')
						app.x1 += 0.1
					}
					.m {
						println('in')
						app.xzoom *= 0.5
						app.yzoom *= 0.5
					}
					.n {
						println('out')
						app.xzoom /= 0.5
						app.yzoom /= 0.5
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
	app.gen = 0
}

// is needed for easier diagnostics on windows
[console]
fn main() {
	println("Press 'q' to quit. Press 'i' to initialize.")
	mut font_path := os.resource_abs_path(os.join_path('..', 'assets', 'fonts', 'RobotoMono-Regular.ttf'))
	$if android {
		font_path = 'fonts/RobotoMono-Regular.ttf'
	}

	mut app := &App{}

	app.gg = gg.new_context(
		width: xsize
		height: ysize
		window_title: 'Conway!'
		bg_color: gx.yellow
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
