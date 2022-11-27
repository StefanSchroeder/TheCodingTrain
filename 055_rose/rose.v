// Draw a rose following the Coding Challenge #xx by
// the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import math
import rand

const (
	center = 200
)

struct App {
mut:
	gg        &gg.Context = unsafe{0}
	draw_flag bool        = true
	numbers   []f32       = []f32{cap: 1000}
	count     int
}

fn on_frame(mut app App) {
	app.count++
	if !app.draw_flag {
		return
	}

	if app.count % 60 == 0 {
		n0 := rand.int_in_range(1, 10) or { return }
		n := f32(n0)
		d0 := rand.int_in_range(1, 10) or { return }
		d := f32(d0)
		k := n / d
		mut a := 0.0
		app.numbers = []
		for (a < 2 * math.pi * d) {
			r := center * math.cos(k * a)
			x := center + r * math.cos(a)
			y := center + r * math.sin(a)
			app.numbers << f32(x)
			app.numbers << f32(y)
			a += 0.01
		}
	}

	app.gg.begin()
	app.gg.draw_pixels(app.numbers, gx.blue)
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
					.q {
						println('Good bye.')
						// do we need to free anything here?
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
}

// is needed for easier diagnostics on windows
[console]
fn main() {
	println("Press 'q' to quit.")
	mut font_path := os.resource_abs_path(os.join_path('..', 'assets', 'fonts', 'RobotoMono-Regular.ttf'))
	$if android {
		font_path = 'fonts/RobotoMono-Regular.ttf'
	}

	mut app := &App{}

	app.gg = gg.new_context(
		width: center * 2
		height: center * 2
		window_title: 'Rose!'
		bg_color: gx.white
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
