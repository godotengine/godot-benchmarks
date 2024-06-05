extends Benchmark

# Ported from
# https://github.com/hanabi1224/Programming-Language-Benchmarks/blob/main/bench/algorithm/nbody/4.lua

const SOLAR_MASS := 4 * PI * PI
const DAYS_PER_YEAR := 365.24


class Nbody:
	var x: float
	var y: float
	var z: float
	var vx: float
	var vy: float
	var vz: float
	var mass: float

	func _init(
		_x: float, _y: float, _z: float, _vx: float, _vy: float, _vz: float, _mass: float
	) -> void:
		x = _x
		y = _y
		z = _z
		vx = _vx
		vy = _vy
		vz = _vz
		mass = _mass


var sun := Nbody.new(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS)
var jupiter := Nbody.new(
	4.84143144246472090e+00,
	-1.16032004402742839e+00,
	-1.03622044471123109e-01,
	1.66007664274403694e-03 * DAYS_PER_YEAR,
	7.69901118419740425e-03 * DAYS_PER_YEAR,
	-6.90460016972063023e-05 * DAYS_PER_YEAR,
	9.54791938424326609e-04 * SOLAR_MASS
)
var saturn := (
	Nbody
	. new(
		8.34336671824457987e+00,
		4.12479856412430479e+00,
		-4.03523417114321381e-01,
		-2.76742510726862411e-03 * DAYS_PER_YEAR,
		4.99852801234917238e-03 * DAYS_PER_YEAR,
		2.30417297573763929e-05 * DAYS_PER_YEAR,
		2.85885980666130812e-04 * SOLAR_MASS,
	)
)
var uranus := (
	Nbody
	. new(
		1.28943695621391310e+01,
		-1.51111514016986312e+01,
		-2.23307578892655734e-01,
		2.96460137564761618e-03 * DAYS_PER_YEAR,
		2.37847173959480950e-03 * DAYS_PER_YEAR,
		-2.96589568540237556e-05 * DAYS_PER_YEAR,
		4.36624404335156298e-05 * SOLAR_MASS,
	)
)
var neptune := (
	Nbody
	. new(
		1.53796971148509165e+01,
		-2.59193146099879641e+01,
		1.79258772950371181e-01,
		2.68067772490389322e-03 * DAYS_PER_YEAR,
		1.62824170038242295e-03 * DAYS_PER_YEAR,
		-9.51592254519715870e-05 * DAYS_PER_YEAR,
		5.15138902046611451e-05 * SOLAR_MASS,
	)
)
var bodies: Array[Nbody] = [sun, jupiter, saturn, uranus, neptune]


func advance(nbody: int, dt: float) -> void:
	for i in nbody:
		var bi := bodies[i]
		var bix := bi.x
		var biy := bi.y
		var biz := bi.z
		var bivx := bi.vx
		var bivy := bi.vy
		var bivz := bi.vz
		var bimass := bi.mass
		for j in range(i + 1, nbody):
			var bj := bodies[j]
			var dx := bix - bj.x
			var dy := biy - bj.y
			var dz := biz - bj.z
			var dist2 := dx * dx + dy * dy + dz * dz
			var mag := sqrt(dist2)
			mag = dt / (mag * dist2)
			var bm := bj.mass * mag
			bivx = bivx - (dx * bm)
			bivy = bivy - (dy * bm)
			bivz = bivz - (dz * bm)
			bm = bimass * mag
			bj.vx = bj.vx + (dx * bm)
			bj.vy = bj.vy + (dy * bm)
			bj.vz = bj.vz + (dz * bm)

		bi.vx = bivx
		bi.vy = bivy
		bi.vz = bivz
		bi.x = bix + dt * bivx
		bi.y = biy + dt * bivy
		bi.z = biz + dt * bivz


func energy(nbody: int) -> float:
	var e := 0.0
	for i in nbody:
		var bi := bodies[i]
		var vx := bi.vx
		var vy := bi.vy
		var vz := bi.vz
		var bim := bi.mass
		e = e + (0.5 * bim * (vx * vx + vy * vy + vz * vz))
		for j in range(i + 1, nbody):
			var bj := bodies[j]
			var dx := bi.x - bj.x
			var dy := bi.y - bj.y
			var dz := bi.z - bj.z
			var distance := sqrt(dx * dx + dy * dy + dz * dz)
			e = e - ((bim * bj.mass) / distance)
	return e


func offset_momentum(b: Array[Nbody], nbody: int):
	var px := 0.0
	var py := 0.0
	var pz := 0.0
	for i in nbody:
		var bi := b[i]
		var bim := bi.mass
		px = px + (bi.vx * bim)
		py = py + (bi.vy * bim)
		pz = pz + (bi.vz * bim)

	b[1].vx = -px / SOLAR_MASS
	b[1].vy = -py / SOLAR_MASS
	b[1].vz = -pz / SOLAR_MASS


func calculate_nbody(n: int) -> void:
	offset_momentum(bodies, bodies.size())
	print("%.9f" % [energy(bodies.size())])
	for i in n:
		advance(bodies.size(), 0.01)
	print("%.9f" % [energy(bodies.size())])


func benchmark_nbody_500_000() -> void:
	calculate_nbody(500_000)


func benchmark_nbody_1_000_000() -> void:
	calculate_nbody(1_000_000)
