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
	hand_color        = gx.black
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
	gg        &gg.Context = unsafe { 0 }
	draw_flag bool        = true
	// constants define the initial state.
	p1      Pendulum = Pendulum{100, 0.2, 0, 10, 0, 0, 0.08, 0}
	p2      Pendulum = Pendulum{100, 0.2, 0, 10, 0, 0, -0.05, 0}
	dots    [trail_lenth]Dot = [trail_lenth]Dot{}
	counter int
	dpi_scale f32 = 1.0
	//hour_hand   []f32 = [f32(250), 250, 300, 250, 300, 300, 250, 300, 250, 300]
	hour_hand   []f32 = [f32(250), 250, 255, 250, 255, 300, 250, 300, 250, 300]
	appangle f32 = 0.0
}

fn on_frame(mut app App) {
	if !app.draw_flag {
		return
	}

	app.gg.begin()

	//app.gg.draw_line(350, 2*350, 350, center,  gx.black)
	app.gg.draw_line(0, 0, 200, 250,  gx.black)
	//i := f32(3) + f32(17) / 60.0
	draw_convex_poly_rotate(mut app.gg, 200, 250, app.dpi_scale, app.hour_hand, hand_color, app.appangle)

	app.gg.end()

	app.counter++
	// Make counter reset to avoid overflow and feature the limitation
	// of the trail.
	app.counter = app.counter % trail_lenth
}

[manualfree]
fn draw_convex_poly_rotate(mut ctx gg.Context, centerx f32, centery f32, dpi_scale f32, points []f32, c gx.Color, angle f32) {
	sa := math.sin(math.pi * angle / 180.0)
	ca := math.cos(math.pi * angle / 180.0)

	mut rotated_points := []f32{cap: points.len}
	for i := 0; i < points.len / 2; i++ {
		x := points[2 * i]
		y := points[2 * i + 1]
		xn := f32((x - centerx) * ca - (y - centery) * sa)
		yn := f32((x - centerx) * sa + (y - centery) * ca)
		rotated_points << (xn + centerx) * dpi_scale
		rotated_points << (yn + centery) * dpi_scale
	}
	ctx.draw_convex_poly(rotated_points, c)
	unsafe { rotated_points.free() }
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
