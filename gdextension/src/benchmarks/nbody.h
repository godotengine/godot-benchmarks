#ifndef CPP_BENCHMARK_NBODY_H
#define CPP_BENCHMARK_NBODY_H

#include "../cppbenchmark.h"

namespace godot {
    class CPPBenchmarkNbody : public CPPBenchmark {
        GDCLASS(CPPBenchmarkNbody, CPPBenchmark)

        private:
            const double Pi = 3.141592653589793;
            const double Solarmass = 4 * Pi * Pi;
            const double DaysPeryear = 365.24;
            struct Body { double x, y, z, vx, vy, vz, mass; };
            const char body_count = 5; // We can use char since this value is small
            Body bodies[5] {
                { // Sun
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Solarmass
                },
                { // Jupiter
                    4.84143144246472090e+00,
                    -1.16032004402742839e+00,
                    -1.03622044471123109e-01,
                    1.66007664274403694e-03*DaysPeryear,
                    7.69901118419740425e-03*DaysPeryear,
                    -6.90460016972063023e-05*DaysPeryear,
                    9.54791938424326609e-04*Solarmass
                },
                { // Saturn
                    8.34336671824457987e+00,
                    4.12479856412430479e+00,
                    -4.03523417114321381e-01,
                    -2.76742510726862411e-03*DaysPeryear,
                    4.99852801234917238e-03*DaysPeryear,
                    2.30417297573763929e-05*DaysPeryear,
                    2.85885980666130812e-04*Solarmass,
                },
                { // Uranus
                    1.28943695621391310e+01,
                    -1.51111514016986312e+01,
                    -2.23307578892655734e-01,
                    2.96460137564761618e-03*DaysPeryear,
                    2.37847173959480950e-03*DaysPeryear,
                    -2.96589568540237556e-05*DaysPeryear,
                    4.36624404335156298e-05*Solarmass,
                },
                { // Neptune
                    1.53796971148509165e+01,
                    -2.59193146099879641e+01,
                    1.79258772950371181e-01,
                    2.68067772490389322e-03*DaysPeryear,
                    1.62824170038242295e-03*DaysPeryear,
                    -9.51592254519715870e-05*DaysPeryear,
                    5.15138902046611451e-05*Solarmass,
                },
            };

            void offset_momentum();
            void advance(double dt);
            double energy();
            void calculate_nbody(int n);
        protected:
	        static void _bind_methods();
        public:
            void benchmark_nbody_500_000();
            void benchmark_nbody_1_000_000();
            CPPBenchmarkNbody();
            ~CPPBenchmarkNbody();
    };
}
#endif
