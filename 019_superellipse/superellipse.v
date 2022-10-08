// Draw a rose following the Coding Challenge #xx by
// the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import math

const (
	center = 200
)

struct App {
mut:
	gg        &gg.Context = unsafe { 0 }
	draw_flag bool        = true
	numbers   []f32       = []f32{cap: 1000}
	count     int
	n         f64 = 5.0
	d         f64 = 5.0
	a         f64 = 100.0
	b         f64 = 100.0
}

fn on_frame(mut app App) {
	app.count++
	if !app.draw_flag {
		return
	}

	if app.count % 10 == 0 {
		if app.d < 1.0 { 
			app.d += 1.0
		}
		if app.n < 1.0 { 
			app.n += 1.0
		}
		mut angle := 0.0
		
		na := 2.0 / app.n
		app.numbers = []
		for (angle < 2 * math.pi * app.d) {
			x := center + math.pow(math.abs(math.cos(angle)), na) * app.a * math.sign(math.cos(angle))
			y := center + math.pow(math.abs(math.sin(angle)), na) * app.b * math.sign(math.sin(angle))
			app.numbers << f32(x)
			app.numbers << f32(y)
			angle += 0.01
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
					.n { app.d += 1 }
					.m { app.d -= 1 }
					.v { app.n += 1 }
					.b { app.n -= 1 }
					.l { app.b += 5 }
					.h { app.b -= 5 }
					.j { app.a += 5 }
					.k { app.a -= 5 }
					.q {
						println('Good bye.')
						app.gg.quit()
					}
					else {}
				}
				println("Values: d=$app.d n=$app.n a=$app.a b=$app.b\n")
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
	println("Press 'q' to quit. Use [vbnmlkjh] to change variables.")
	mut font_path := os.resource_abs_path(os.join_path('..', 'assets', 'fonts', 'RobotoMono-Regular.ttf'))
	$if android {
		font_path = 'fonts/RobotoMono-Regular.ttf'
	}

	mut app := &App{}

	app.gg = gg.new_context(
		width: center * 2
		height: center * 2
		window_title: 'Superellipse!'
		bg_color: gx.white
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
