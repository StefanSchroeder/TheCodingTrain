// Bezier curve, the Coding Challenge #163 by the Coding Train.
// Written by Stefan Schroeder in 2023 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import rand

const (
	xsize      = 500 // number of cells in x direction
	ysize      = 500
	show_every = 15 // display every n-th frame
)

struct App {
mut:
	gen       int // generation counter
	gg        &gg.Context = unsafe{0}
	draw_flag bool        = true
	grid      [][]byte    = [][]byte{len: xsize, init: []byte{len: ysize}}
	x         int // x-position of ant
	y         int // y-position of ant
	rax       int // x-position of first control point
	ray       int // x-position of first control point
	rbx       int // x-position of secnd control point
	rby       int // x-position of secnd control point
	dir       int // direction of ant
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	if app.gen % show_every == 0 {
		app.gg.begin()
		points := [f32(0), ysize/2, app.rax, app.ray, app.rbx, app.rby, xsize, ysize/2]
		app.gg.draw_cubic_bezier(points,  gx.white)
		app.gg.draw_rect_filled(app.rax, app.ray, 2, 2, gx.white)
		app.gg.draw_rect_filled(app.rbx, app.rby, 2, 2, gx.white)
		app.gg.end()
	}

	new_dir := rand.int_in_range(0, 4) or { return }
	app.x, app.y = move_forward(new_dir, app.x, app.y)

	new_dir1 := rand.int_in_range(0, 4) or { return }
	app.rax, app.ray = move_forward(new_dir1, app.rax, app.ray)

	new_dir2 := rand.int_in_range(0, 4) or { return }
	app.rbx, app.rby = move_forward(new_dir2, app.rbx, app.rby)

	app.x, app.y = move_forward(new_dir, app.x, app.y)
	app.dir = new_dir

	app.grid[app.x][app.y] = 1 // switch state

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

fn move_forward(dir int, x int, y int) (int, int) {
	mut newx := x
	mut newy := y

	match dir {
		0 { newy-- }
		1 { newy++ }
		2 { newx++ }
		3 { newx-- }
		else { panic('How did you get here?') }
	}
	newx = (newx + xsize) % xsize // wrap around edges
	newy = (newy + ysize) % ysize
	return newx, newy
}

fn on_init(mut app App) {
	app.resize()

	app.gen = 0
	app.x = xsize / 2
	app.y = ysize / 2
	app.dir = 0

	app.rax = xsize / 3
	app.ray = ysize / 3
	app.rbx = 2*xsize / 3
	app.rby = 2*ysize / 3
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
		window_title: "Random walk"
		bg_color: gx.black
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
