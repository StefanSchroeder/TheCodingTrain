// A fractal tree generator following the Coding Challenge #14
// by the Coding Train.
// Since there is no global 'translate' or 'rotate' we are doing
// some vector arithetic to accomomplish the same effect
// in a global co-system.
// Written by Stefan Schroeder in 2022.
// See LICENSE for license information.
import os
import gg
import gx
import math

const ( center      = 350 )

struct Vec {
	x f32
	y f32
}


fn (a Vec) + (b Vec) Vec {
	return Vec{a.x + b.x, a.y + b.y}
}

struct App {
mut:
	gg        &gg.Context = unsafe { 0 }
	draw_flag bool        = true
	deltaangle f32 = 5.0
}

// Draws one branch and dispatches drawing of two child branches.
// Takes a context, the offset, length and rotation-angle as
// arguments.
fn branch(mut app App, offset Vec, length f32, angle f32) {
	if length < 3 {
		return 
	}
	newv := offset + rotate_vev( Vec{ 0, length }, angle ) 
	app.gg.draw_line(offset.x, 2*center - offset.y, newv.x, 2 * center - newv.y, gx.black)

	branch(mut app, newv, length*0.75, angle + app.deltaangle)
	branch(mut app, newv, length*0.75, angle - app.deltaangle)

}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	app.gg.begin()
	branch(mut app, Vec{center, 0}, 100, 0)
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
						app.deltaangle += 3.0
					}
					.e {
						app.deltaangle -= 3.0
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
	println("Press 'q' to quit or '[we]' to change angle.")
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
