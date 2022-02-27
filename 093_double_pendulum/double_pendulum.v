// A double pendulum following the Coding Challenge #95 by
// the Coding Train.
// Draws a square canvas with pendulums, one attached
// to the other, showing stunning chaotic movements.
// You may press 'k' to give the pendulum a good
// kick, because the dampening will cause it to stop after
// a while.
// Written by Stefan Schroeder in 2021 for the v project examples.
// See LICENSE for license information.
import os
import gg
import gx
import math

const (
	center      = 350
	g           = 0.1 // gravity constant
	// The dampening is necessary to avoid that rounding
	// errors will add infinite energy into the system.
	dampening   = 0.999
	trail_lenth = 250
)

struct Pendulum {
mut:
	r   f32 // radius, arm length
	m   f32 // mass
	a   f32 // angle
	rd  f32 // radius of blob
	x   f32 // x-coord computed value
	y   f32 // y-coord computed value
	v   f32 // velocity computed
	acc f32 // acceleration computed
}

// A Dot is used to store an array of tiny marks for the trail.
struct Dot {
	x f32
	y f32
}

struct App {
mut:
	gg        &gg.Context = 0
	draw_flag bool        = true
	// constants define the initial state.
	p1      Pendulum = Pendulum{100, 0.2, 0, 10, 0, 0, 0.08, 0}
	p2      Pendulum = Pendulum{100, 0.2, 0, 10, 0, 0, -0.05, 0}
	dots    [trail_lenth]Dot = [trail_lenth]Dot{}
	counter int
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	// rename vars for brevity
	m1 := app.p1.m
	m2 := app.p2.m
	a1 := app.p1.a
	a2 := app.p2.a
	v1 := app.p1.v
	v2 := app.p2.v
	r1 := app.p1.r
	r2 := app.p2.r

	// Compute the new angle based on the complicated formula.
	num1 := -g * (2 * m1 + m2) * math.sin(a1)
	num2 := -m2 * g * math.sin(a1 - 2 * a2)
	num3 := -2 * math.sin(a1 - a2) * m2
	num4 := v2 * v2 * r2 + v1 * v1 * r1 * math.cos(a1 - a2)
	den := r1 * (2 * m1 + m2 - m2 * math.cos(2 * a1 - 2 * a2))
	app.p1.acc = f32((num1 + num2 + num3 * num4) / den)

	numb1 := 2 * math.sin(a1 - a2)
	numb2 := (v1 * v1 * r1 * (m1 + m2))
	numb3 := g * (m1 + m2) * math.cos(a1)
	numb4 := v2 * v2 * r2 * m2 * math.cos(a1 - a2)
	denb := r2 * (2 * m1 + m2 - m2 * math.cos(2 * a1 - 2 * a2))
	app.p2.acc = f32((numb1 * (numb2 + numb3 + numb4)) / denb)

	app.p1.v += app.p1.acc
	app.p2.v += app.p2.acc
	app.p1.v *= dampening
	app.p2.v *= dampening
	app.p1.a += app.p1.v
	app.p2.a += app.p2.v

	// Using the new angle, compute the new locations:
	x1 := f32(r1 * math.sin(app.p1.a))
	y1 := f32(r1 * math.cos(app.p1.a))
	x2 := f32(x1 + r2 * math.sin(app.p2.a))
	y2 := f32(y1 + r2 * math.cos(app.p2.a))

	app.gg.begin()

	// Add the new Dot at the current location of second pendulum
	app.dots[app.counter] = Dot{x2, y2}
	// Draw all dots in the list of all dots.
	for d in app.dots {
		app.gg.draw_ellipse_filled(d.x + center, d.y + center, 1, 1, gx.black)
	}

	// Line from origin to first mass
	app.gg.draw_line(0 + center, 0 + center, x1 + center, y1 + center, gx.black)
	// Blob for first pendulum
	app.gg.draw_ellipse_filled(x1 + center, y1 + center, app.p1.rd, app.p1.rd, gx.black)
	// Line from first mass to second mass
	app.gg.draw_line(x1 + center, y1 + center, x2 + center, y2 + center, gx.black)
	// Blob for second pendulum
	app.gg.draw_ellipse_filled(x2 + center, y2 + center, app.p2.rd, app.p2.rd, gx.black)

	app.gg.end()

	app.counter++
	// Make counter reset to avoid overflow and feature the limitation
	// of the trail.
	app.counter = app.counter % trail_lenth
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
					.k {
						println('Kick!')
						app.p1.v += 0.1
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
		window_title: 'Double Pendulum!'
		bg_color: gx.white
		user_data: app
		frame_fn: on_frame
		event_fn: on_event
		init_fn: on_init
		font_path: font_path
	)

	app.gg.run()
}
