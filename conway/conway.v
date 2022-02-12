// Conway's Game of Life, the Coding Challenge #85 by the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import rand

const (
	xsize  = 100
	xscale = 4
	ysize  = 100 // when set to 105 fails.
	yscale = 4
)

struct App {
mut:
	gen       int
	gg        &gg.Context = 0
	draw_flag bool        = true
	grid      [][]byte     = [][]byte{len: xsize, init: []byte{len: ysize}}
	newgrid   [][]byte     = [][]byte{len: xsize, init: []byte{len: ysize}}
}

fn neighbor_count(array [][]byte, xo int, yo int) int {
	mut sum := 0

	// Computed wrapped coords.
	xp := (xo + 1) % xsize
	xm := (xo - 1 + xsize) % xsize
	yp := (yo + 1) % ysize
	ym := (yo - 1 + ysize) % ysize

	sum += array[xm][ym]
	sum += array[xp][ym]
	sum += array[xm][yp]
	sum += array[xp][yp]

	sum += array[xm][yo]
	sum += array[xp][yo]
	sum += array[xo][ym]
	sum += array[xo][yp]

	return sum
}

fn on_frame(mut app App) {
	app.gen += 1
	if !app.draw_flag {
		return
	}
	app.gg.begin()

	// Draw grid
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			if app.grid[i][j] == 1 {
				app.gg.draw_rect_filled(i * xscale, j * yscale, xscale, yscale, gx.white)
			} else {
				app.gg.draw_rect_filled(i * xscale, j * yscale, xscale, yscale, gx.black)
			}
		}
	}

	// Compute next generation
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			nc := neighbor_count(app.grid, i, j)
			if app.grid[i][j] == 0 && nc == 3 {
				app.newgrid[i][j] = 1 // Rule populate
			} else if app.grid[i][j] == 1 && (nc < 2 || nc > 3) {
				app.newgrid[i][j] = 0 // Rule die
			} else {
				app.newgrid[i][j] = app.grid[i][j] // Rule keep
			}
		}
	}
	// Copy newgrid to grid
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			app.grid[i][j] = app.newgrid[i][j]
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

fn on_init(mut app App) {
	app.resize()

	// Populate grid with bunch of 1's and 0's
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			app.grid[i][j] = byte(rand.intn(256) % 2)
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
		width:  xsize * xscale
		height:  ysize * yscale
		window_title: 'Conway!'
		bg_color: gx.black
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
