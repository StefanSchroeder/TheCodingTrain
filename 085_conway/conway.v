// Conway's Game of Life, the Coding Challenge #85 by the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import rand

// The cells are stored in a 3d grid. 2d are used for the actual grid,
// the third dimension is used for the CURRENT generation and the
// NEXT generation, always jump from plane 0 to plane 1 and from
// plane 1 to plane 0, thus avoiding any copy operation.
const (
	xsize  = 100 // number of cells in x direction
	xscale = 5 // size of one cell square
	ysize  = 100 
	yscale = 5
)

struct App {
mut:
	gen       int
	gg        &gg.Context = 0
	draw_flag bool        = true
	grid      [][][]byte  = [][][]byte{len: xsize, init: [][]byte{len: ysize, init: []byte{len: 2}}}
}

// Counts and returns the number of neighbors at the position
// (x,y) taking wrapping into account. Looking at plane 'p'.
fn neighbor_count(array [][][]byte, p byte, xo int, yo int) int {
	mut sum := 0

	// Compute wrapped coords.
	xp := (xo + 1) % xsize
	xm := (xo - 1 + xsize) % xsize
	yp := (yo + 1) % ysize
	ym := (yo - 1 + ysize) % ysize

	//   -----------------------> x
	//  |     A       B         C
	//  | (x-1,y-1) (x,y-1) (x+1,y-1)
	//  |     D      self       E
	//  | (x-1,y)   (x,y)   (x+1,y)
	//  |     F       G         H
	//  | (x-1,y+1) (x,y+1) (x+1,y+1)
	//  y
	//
	sum += array[xm][ym][p] // A
	sum += array[xo][ym][p] // B
	sum += array[xp][ym][p] // C

	sum += array[xm][yo][p] // D
	sum += array[xp][yo][p] // E

	sum += array[xm][yp][p] // F
	sum += array[xo][yp][p] // G
	sum += array[xp][yp][p] // H

	return sum
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	// Toggle btw plane 0 and 1
	tg := byte(app.gen % 2) // THIS generation
	ng := (tg + 1) % 2 // NEXT generation

	// Draw current generation
	app.gg.begin()
	for i in 0 .. xsize  {
		for j in 0 .. ysize {
			if app.grid[i][j][tg] == 1 {
				app.gg.draw_rect_filled(i * xscale, j * yscale, xscale, yscale, gx.white)
			} else {
				app.gg.draw_rect_filled(i * xscale, j * yscale, xscale, yscale, gx.blue)
			}
		}
	}
	app.gg.end()

	// Compute next generation
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			nc := neighbor_count(app.grid, tg, i, j)
			if app.grid[i][j][tg] == 0 && nc == 3 {
				app.grid[i][j][ng] = 1 // Rule "Populate"
			} else if app.grid[i][j][tg] == 1 && (nc < 2 || nc > 3) {
				app.grid[i][j][ng] = 0 // Rule "Die"
			} else {
				app.grid[i][j][ng] = app.grid[i][j][tg] // Rule "Keep"
			}
		}
	}
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

fn on_init(mut app App) {
	app.resize()

	app.gen = 0
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			app.grid[i][j][0] = byte(rand.intn(256) % 2)
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
