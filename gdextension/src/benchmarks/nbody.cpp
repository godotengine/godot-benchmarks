#include "nbody.h"
#include <godot_cpp/core/class_db.hpp>

#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void CPPBenchmarkNbody::_bind_methods() {
    ClassDB::bind_method(D_METHOD("benchmark_nbody_500_000"), &CPPBenchmarkNbody::benchmark_nbody_500_000);
    ClassDB::bind_method(D_METHOD("benchmark_nbody_1_000_000"), &CPPBenchmarkNbody::benchmark_nbody_1_000_000);
}

void CPPBenchmarkNbody::offset_momentum() {
    double px = 0, py = 0, pz = 0;
    for(char i = 0; i < body_count; i++) {
        Body b = bodies[i];
        px -= b.vx * b.mass;
        py -= b.vy * b.mass;
        pz -= b.vz * b.mass;
    }
    Body sol = bodies[0];
    bodies[0].vx = px / Solarmass;
    bodies[0].vy = py / Solarmass;
    bodies[0].vz = pz / Solarmass;
}

void CPPBenchmarkNbody::advance(double dt) {
    for (char i = 0; i < body_count; i++) {
        double x = bodies[i].x;
        double y = bodies[i].y;
        double z = bodies[i].z;
        double vx = bodies[i].vx;
        double vy = bodies[i].vy;
        double vz = bodies[i].vz;
        double mi = bodies[i].mass;
        for (char j = i + 1; j < body_count; j++) {
            double dx = x - bodies[j].x;
            double dy = y - bodies[j].y;
            double dz = z - bodies[j].z;
            double d2 = dx * dx + dy * dy + dz * dz;
            double mag = dt / (d2 * godot::Math::sqrt(d2));
            double bj_m_mag = bodies[j].mass * mag;
            vx -= dx * bj_m_mag;
            vy -= dy * bj_m_mag;
            vz -= dz * bj_m_mag;

            double bi_m_mag = mi * mag;
            bodies[j].vx += dx * bi_m_mag;
            bodies[j].vy += dy * bi_m_mag;
            bodies[j].vz += dz * bi_m_mag;
        }
        bodies[i].vx = vx;
        bodies[i].vy = vy;
        bodies[i].vz = vz;

        bodies[i].x += vx * dt;
        bodies[i].y += vy * dt;
        bodies[i].z += vz * dt;
    }
}

double CPPBenchmarkNbody::energy() {
    double e = 0.0;
    for (int i = 0; i < body_count; i++) {
        e += 0.5 * bodies[i].mass * (bodies[i].vx * bodies[i].vx + bodies[i].vy * bodies[i].vy + bodies[i].vz * bodies[i].vz);
        for (int j = i + 1; j < body_count; j++) {
            double dx = bodies[i].x - bodies[j].x, dy = bodies[i].y - bodies[j].y, dz = bodies[i].z - bodies[j].z;
            e -= (bodies[i].mass * bodies[j].mass) / godot::Math::sqrt(dx * dx + dy * dy + dz * dz);
        }
    }
    return e;
}

void CPPBenchmarkNbody::calculate_nbody(int n) {
    offset_momentum();
    godot::UtilityFunctions::print(energy());
    for (int i = 0; i < n; i++) {
        advance(0.01);
    }
    godot::UtilityFunctions::print(energy());
}

void CPPBenchmarkNbody::benchmark_nbody_500_000() {
	calculate_nbody(500000);
}

void CPPBenchmarkNbody::benchmark_nbody_1_000_000() {
	calculate_nbody(1000000);
}

CPPBenchmarkNbody::CPPBenchmarkNbody() {}

CPPBenchmarkNbody::~CPPBenchmarkNbody() {}
