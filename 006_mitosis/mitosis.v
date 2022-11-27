// Random Walk, the Coding Challenge #52 by the Coding Train.
// This is essentially a dumb version of Langton's ant.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import rand
import math

const (
	center     = 350
	show_every = 15 // display every n-th frame
	radius = 15
)

struct Cell {
mut:
	x int
	y int
	r int
}

struct App {
mut:
	gen       int // generation counter
	gg        &gg.Context = unsafe{0}
	draw_flag bool        = true
	cells     []Cell      = []Cell{}
	number_of_initial_cells int = 10
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	if app.gen % show_every == 0 {
		app.gg.begin()
		for i in app.cells {
			app.gg.draw_circle_filled(i.x, i.y, i.r, gx.red)
		}
		app.gg.end()
	}

	for mut i in app.cells {
		new_dir := rand.int_in_range(0, 4) or { return }
		match new_dir {
			0 { i.x++ }
			1 { i.x-- }
			2 { i.y++ }
			3 { i.y-- }
			else { panic('How did you get here?') }
		}
	}

	app.gen += 1
}

// when finding the closest cell, we compare 
// the squares of the distances.
fn (mut app App) mark_cell(x f32, y f32) {
	mut closest := 0
	mut c := app.cells[closest]
	mut shortest := math.pow(x - c.x, 2) + math.pow(y - c.y, 2)
	for i in 0 .. app.cells.len {
		dist := math.pow(app.cells[i].x - x, 2) + math.pow(app.cells[i].y - y, 2)
		if dist < shortest {
			shortest = dist
			closest = i
		}
	}
	// duplicate the found cell
	app.cells << Cell{ app.cells[closest].x, app.cells[closest].y, radius }
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
			if e.typ == .mouse_down {
				if e.mouse_button == .left {
					app.mark_cell(e.mouse_x, e.mouse_y)
				}
			}
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


fn on_init(mut app App) {
	app.resize()

	app.gen = 0
	for _ in 0 .. app.number_of_initial_cells {
		x := rand.int_in_range(0, 2*center) or { return }
		y := rand.int_in_range(0, 2*center) or { return }
		app.cells << Cell{ x, y, radius }
	}
}

// is needed for easier diagnostics on windows
[console]
fn main() {
	println("Press 'q' to quit. Use left mouse to split cell.")
	mut font_path := os.resource_abs_path(os.join_path('..', 'assets', 'fonts', 'RobotoMono-Regular.ttf'))
	$if android {
		font_path = 'fonts/RobotoMono-Regular.ttf'
	}

	mut app := &App{}

	app.gg = gg.new_context(
		width: center * 2
		height: center * 2
		window_title: "Mitosis"
		bg_color: gx.black
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}

