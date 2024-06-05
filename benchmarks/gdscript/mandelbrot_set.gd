extends Benchmark

const WIDTH := 600
const HEIGHT := 400
const MAX_ITERATION := 1000


func hsv(hue: float, sat: float, value: float) -> Color:
	hue = fposmod(hue, 360.0)
	var h := floori(hue) / 60
	var f := hue / 60.0 - h
	var p := value * (1.0 - sat)
	var q := value * (1.0 - sat * f)
	var t = value * (1.0 - sat * (1.0 - f))
	if h == 0 or h == 6:
		return Color(value, t, p)
	if h == 1:
		return Color(q, value, p)
	if h == 2:
		return Color(p, value, t)
	if h == 3:
		return Color(p, q, value)
	if h == 4:
		return Color(t, p, value)
	return Color(value, p, q)


func mandelbrot_set(width: int, height: int, max_iteration: int) -> void:
	var image := Image.create(width, height, false, Image.FORMAT_RGB8)
	var ratio := float(width) / float(height)
	var x_range := 3.6
	var y_range := x_range / ratio
	var min_x := -x_range / 2
	var max_y := y_range / 2
	for x in image.get_width():
		for y in image.get_height():
			var iteration := 0
			var x0 := min_x + x_range * x / width
			var y0 := max_y - y_range * y / height
			var xx := 0.0
			var yy := 0.0
			var x2 := 0.0
			var y2 := 0.0
			while x2 + y2 <= 4 and iteration < max_iteration:
				yy = 2 * xx * yy + y0
				xx = x2 - y2 + x0
				x2 = xx * xx
				y2 = yy * yy
				iteration += 1
			var m := float(iteration) / float(max_iteration)
			var color := hsv(360.0 * m, 1.0, ceilf(1.0 - 1.1 * m))
			image.set_pixel(x, y, color)


func benchmark_mandelbrot_set() -> void:
	mandelbrot_set(WIDTH, HEIGHT, MAX_ITERATION)
