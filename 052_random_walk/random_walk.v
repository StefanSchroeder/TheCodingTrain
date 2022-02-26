// Random Walk, the Coding Challenge #52 by the Coding Train.
// This is essentially a dumb version of Langton's ant.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import rand

const (
	xsize      = 100 // number of cells in x direction
	xscale     = 5 // size of one cell square
	ysize      = 100
	yscale     = 5
	show_every = 15 // display every n-th frame
)

struct App {
mut:
	gen       int // generation counter
	gg        &gg.Context = 0
	draw_flag bool        = true
	grid      [][]byte    = [][]byte{len: xsize, init: []byte{len: ysize}}
	x         int // x-position of ant
	y         int // y-position of ant
	dir       int // direction of ant
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	// Draw current generation
	if app.gen % show_every == 0 {
		app.gg.begin()
		for i in 0 .. xsize {
			for j in 0 .. ysize {
				if app.grid[i][j] == 1 {
					app.gg.draw_rect_filled(i * xscale, j * yscale, xscale, yscale, gx.white)
				} else {
					//app.gg.draw_rect_filled(i * xscale, j * yscale, xscale, yscale, gx.black)
				}
			}
		}
		app.gg.end()
	}

	mut new_dir := rand.int_in_range(0, 4)

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

	for i in 0 .. xsize {
		for j in 0 .. ysize {
			app.grid[i][j] = 0
		}
	}
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
		width: xsize * xscale
		height: ysize * yscale
		window_title: "Langton's ant!"
		bg_color: gx.black
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
