// A purple rain canvas the Coding Challenge #4 by
// the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import rand

const (
	xsize      = 640
	ysize      = 360
	drop_count = 500
)

struct Drop {
mut:
	x      f32
	y      f32
	z      f32
	len    f32
	yspeed f32
}

struct App {
mut:
	gg        &gg.Context = 0
	draw_flag bool        = true
	drops     []Drop      = []Drop{}
	dropcolor gx.Color    = gx.Color{139, 43, 226, 255}
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}
	app.gg.begin()

	for i in 0 .. drop_count {
		app.drops[i].y += app.drops[i].yspeed
		grav := mymap(app.drops[i].z, 0, 20, 0, 0.2)
		app.drops[i].yspeed += grav
		thickness := int(mymap(app.drops[i].z, 0, 20, 1, 3))
		penc := gg.PenConfig{app.dropcolor, .solid, thickness}
		app.gg.draw_line_with_config(app.drops[i].x, app.drops[i].y, app.drops[i].x,
			app.drops[i].y + app.drops[i].len, penc)
		if app.drops[i].y > ysize {
			// reinvent the drop
			app.drops[i].x = rand.f32_in_range(0.0, xsize) or { return }
			app.drops[i].y = rand.f32_in_range(-1 * ysize, -50) or { return }
			z := rand.f32_in_range(0, 20) or { return }
			app.drops[i].z = z
			app.drops[i].len = mymap(z, 0, 20, 10, 20)
			app.drops[i].yspeed = mymap(z, 0, 20, 1, 20)
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

// mymap projects the interval a,b to the interval c,d linearly.
// This is called map in Processing, but in v it's already used.
// it's your responsiblity to not divide by zero.
// That means you cannot have a==b.
fn mymap(v f64, a f64, b f64, c f64, d f64) f32 {
	m := (c - d) / (a - b)
	n := c - (a * m)
	return f32(v * m + n)
}

fn on_init(mut app App) {
	app.resize()

	// In the beginning, create the drops.
	for _ in 0 .. drop_count {
		x := rand.f32_in_range(0.0, xsize) or { return } 
		y := rand.f32_in_range(-1 * ysize, -50) or { return } 
		z := rand.f32_in_range(0, 20) or { return } 
		len := mymap(z, 0, 20, 10, 20)
		yspeed := mymap(z, 0, 20, 1, 20)
		app.drops << Drop{x, y, z, len, yspeed}
	}
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

	bgcolor := gx.Color{230, 230, 250, 128}

	app.gg = gg.new_context(
		width: xsize
		height: ysize
		window_title: 'Purple Rain!'
		bg_color: bgcolor
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
