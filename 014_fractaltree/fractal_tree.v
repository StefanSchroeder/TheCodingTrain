// A fractal tree generator following the Coding Challenge #14
// by the Coding Train.
// Written by Stefan Schroeder in 2022.
// See LICENSE for license information.
import os
import gg
import gx
import math

const (
	center      = 350
)

struct Vec {
	x f32
	y f32
}

fn (a Vec) str() string {
	return '{$a.x, $a.y}'
}

fn (a Vec) + (b Vec) Vec {
	return Vec{a.x + b.x, a.y + b.y}
}

fn (a Vec) - (b Vec) Vec {
	return Vec{a.x - b.x, a.y - b.y}
}

struct App {
mut:
	gg        &gg.Context = unsafe { 0 }
	draw_flag bool        = true
	// constants define the initial state.
	dpi_scale f32 = 1.0
	appangle f32 = 0.0
	x0 int = 0
	y0 int = 0
	angle f32 = 0.0
}

// returns the non-offset end of the line 
fn stick(mut app App, offset Vec, length f32, angle int) {
	if length < 5 {
		return 
	}
	rv := rotate_vev( Vec{ 0, length }, angle ) 
	newv := Vec { offset.x + rv.x, offset.y + rv.y}
	app.gg.draw_line(offset.x, 2*center - offset.y, newv.x, 2 * center - newv.y, gx.black)

	stick(mut app, newv, length*0.75, angle + 10)
	stick(mut app, newv, length*0.75, angle - 10)

}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	app.gg.begin()

	o := Vec{center, 0}
	stick(mut app, o, 100, 0)

	app.gg.end()

}

fn rotate_vev(v Vec, angle f32) (Vec) {
	sa := math.sin(math.pi * angle / 180.0)
	ca := math.cos(math.pi * angle / 180.0)
	xn := f32(v.x * ca - v.y * sa)
	yn := f32(v.x * sa + v.y * ca)
	return Vec{ xn, yn }
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
					.w {
						app.appangle += 5.0
					}
					.e {
						app.appangle -= 5.0
					}
					else {}
				}
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
	println("Press 'q' to quit or 'k' to kick.")
	mut font_path := os.resource_abs_path(os.join_path('..', 'assets', 'fonts', 'RobotoMono-Regular.ttf'))
	$if android {
		font_path = 'fonts/RobotoMono-Regular.ttf'
	}

	mut app := &App{}

	app.gg = gg.new_context(
		width: center * 2
		height: center * 2
		window_title: 'Fractal Tree'
		bg_color: gx.white
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
