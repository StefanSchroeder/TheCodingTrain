// Conway's Game of Life, the Coding Challenge #85 by the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import rand

const (
	xsize      = 100
	xscale     = 5
	ysize      = 100
	yscale     = 5
)

struct App {
mut:
	gen       int 
	gg        &gg.Context = 0
	draw_flag bool        = true
	grid      [][]int     = [][]int{len: xsize, init: []int{len: ysize}}
	newgrid   [][]int     = [][]int{len: xsize, init: []int{len: ysize}}
}

fn neighbor_count(array [][]int, xn int, yn int) int {
	mut sum := 0
	x := (xn + xsize) % xsize
	y := (yn + ysize) % ysize
	if x>0 && y>0 {
		sum += array[x-1][y-1]
	}
	if y>0 && x<xsize-1{
		sum += array[x+1][y-1]
	}
	if x>0 && y<ysize-1 {
		sum += array[x-1][y+1]
	}
	if x<xsize-1 && y<ysize-1 {
		sum += array[x+1][y+1]
	}

	if x > 0 {
		sum += array[x-1][y]
	}
	if x < xsize-1 {
		sum += array[x+1][y]
	}
	if y>0 {
		sum += array[x  ][y-1]
	}
	if y<ysize-1 {
		sum += array[x  ][y+1]
	}
	return sum
}
fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}
	app.gg.begin()

	// Draw grid
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			if app.grid[i][j] == 1 {
				app.gg.draw_rect_filled(i*xscale, j*yscale, xscale, yscale, gx.white)
			} else {
				app.gg.draw_rect_filled(i*xscale, j*yscale, xscale, yscale, gx.black)
			}
		}
	}
	
	// Clear new grid
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			app.newgrid[i][j] = 0
		}
	}
	// Compute next generation
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			nc := neighbor_count(app.grid, i, j)
			if app.grid[i][j] == 0 && nc == 3 {
				app.newgrid[i][j] = 1
			} else if app.grid[i][j] == 1 && (nc < 2 || nc > 3) {
				app.newgrid[i][j] = 0
			} else {
				app.newgrid[i][j] = app.grid[i][j]
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
			app.grid[i][j] = rand.intn(65000) % 2
		}
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
		width: xsize*xscale
		height: ysize*yscale
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
