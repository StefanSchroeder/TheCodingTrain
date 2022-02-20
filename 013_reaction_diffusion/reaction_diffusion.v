// Reaction Diffusion Coding Challenge #13 by the Coding Train.
// Written by Stefan Schroeder in 2022 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx

const (
	xsize = 200
	ysize = 200
	da    = 1.0
	db    = 0.5
	feed  = 0.055
	k     = 0.062
)

struct Dot {
mut:
	a f64
	b f64
}

struct App {
mut:
	gen       int
	gg        &gg.Context = 0
	draw_flag bool        = true
	grid      [][][]Dot   = [][][]Dot{len: xsize, init: [][]Dot{len: ysize, init: []Dot{len: 2}}}
}

fn constrain_int(v int, lower int, upper int) int {
	if v < lower {
		return lower
	}
	if v > upper {
		return upper
	}
	return v
}

fn constrain(v f64, lower f64, upper f64) f64 {
	if v < lower {
		return lower
	}
	if v > upper {
		return upper
	}
	return v
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	// Toggle btw plane 0 and 1
	tg := byte(app.gen % 2) // THIS generation
	ng := (tg + 1) % 2 // NEXT generation

	for x in 1 .. xsize - 1 {
		for y in 1 .. ysize - 1 {
			a := app.grid[x][y][tg].a
			b := app.grid[x][y][tg].b
			app.grid[x][y][ng].a = a + da * laplace_a(app.grid, tg, x, y) - a * b * b +
				feed * (1 - a)
			app.grid[x][y][ng].b = b + db * laplace_b(app.grid, tg, x, y) + a * b * b - (k + feed) * b

			app.grid[x][y][ng].a = constrain(app.grid[x][y][ng].a, 0.0, 1.0)
			app.grid[x][y][ng].b = constrain(app.grid[x][y][ng].b, 0.0, 1.0)
		}
	}

	app.gg.begin()
	for x in 0 .. xsize {
		for y in 0 .. ysize {
			a := app.grid[x][y][ng].a
			b := app.grid[x][y][ng].b
			mut c := byte((a - b) * 255)
			c = byte(constrain_int(c, 0, 255))
			col := gx.Color{
				r: c
				g: c
				b: c
			}
			app.gg.draw_pixel(x, y, col)
		}
	}
	app.gg.end()

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
	// bring out seed
	for i in 0 .. xsize {
		for j in 0 .. ysize {
			app.grid[i][j][0] = Dot{1.0, 0.0}
			app.grid[i][j][1] = Dot{1.0, 0.0}
			if i > 95 && i < 105 && j > 95 && j < 105 {
				app.grid[i][j][0] = Dot{1.0, 1.0}
			}
		}
	}
}

fn laplace_a(grid [][][]Dot, index int, x int, y int) f64 {
	mut sum_a := 0.0
	sum_a += grid[x][y][index].a * -1
	sum_a += grid[x - 1][y][index].a * 0.2
	sum_a += grid[x + 1][y][index].a * 0.2
	sum_a += grid[x][y + 1][index].a * 0.2
	sum_a += grid[x][y - 1][index].a * 0.2
	sum_a += grid[x - 1][y - 1][index].a * 0.05
	sum_a += grid[x + 1][y - 1][index].a * 0.05
	sum_a += grid[x + 1][y + 1][index].a * 0.05
	sum_a += grid[x - 1][y + 1][index].a * 0.05
	return sum_a
}

fn laplace_b(grid [][][]Dot, index int, x int, y int) f64 {
	mut sum_b := 0.0
	sum_b += grid[x][y][index].b * -1
	sum_b += grid[x - 1][y][index].b * 0.2
	sum_b += grid[x + 1][y][index].b * 0.2
	sum_b += grid[x][y + 1][index].b * 0.2
	sum_b += grid[x][y - 1][index].b * 0.2
	sum_b += grid[x - 1][y - 1][index].b * 0.05
	sum_b += grid[x + 1][y - 1][index].b * 0.05
	sum_b += grid[x + 1][y + 1][index].b * 0.05
	sum_b += grid[x - 1][y + 1][index].b * 0.05
	return sum_b
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
		window_title: 'Reaction Diffusion!'
		bg_color: gx.yellow
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
