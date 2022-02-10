// A starfield modelled after the Coding Challenge #1 by
// the Coding Train.
// Written by Stefan Schroeder in 2021 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import rand

const (
	center      = 350
	star_count  = 400
	star_size   = 6 // initial size of stars
	size_scale  = 3 // how quickly the size changes
	speed_scale = 5 // relative speed of stars
)

struct Star {
mut:
	x f32
	y f32
	z f32
	r f32
}

struct App {
mut:
	gg        &gg.Context = 0
	draw_flag bool        = true
	stars     []Star      = []Star{}
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}
	app.gg.begin()

	size := gg.window_size()

	for i in 0 .. star_count {
		app.stars[i].z -= 1
		if app.stars[i].z < 1 { // reached the center, reset
			app.stars[i].y = rand.f32_in_range(-center, center)
			app.stars[i].x = rand.f32_in_range(-center, center)
			app.stars[i].z = rand.f32_in_range(0, center)
		} else {
			sx := app.stars[i].x / app.stars[i].z * speed_scale
			sy := app.stars[i].y / app.stars[i].z * speed_scale
			rdisplay := app.stars[i].r / app.stars[i].z * size_scale
			app.gg.draw_ellipse_filled(sx + f32(size.width) / 2, sy + f32(size.height) / 2,
				rdisplay, rdisplay, gx.white)
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

	// In the beginning, create the stars.
	for _ in 0 .. star_count {
		x := rand.f32_in_range(-center, center)
		y := rand.f32_in_range(-center, center)
		z := rand.f32_in_range(0, center)
		app.stars << Star{x, y, z, star_size}
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

	app.gg = gg.new_context(
		width: center * 2
		height: center * 2
		window_title: 'Starfield!'
		bg_color: gx.black
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
