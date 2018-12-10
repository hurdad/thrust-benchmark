#include <benchmark/benchmark.h>

#include <thrust/host_vector.h>
#include <thrust/generate.h>
#include <thrust/device_vector.h>
#include <iostream>
#include <cufft.h>
#include <thrust/execution_policy.h>

struct init_int {
	__host__ __device__
	int operator()() {
		return 1;
	}
};

static void thrust_generate_int(benchmark::State& state) {
	int N = state.range(0);
	thrust::host_vector<int> h_vec(N);

	// transfer data to the device
	thrust::device_vector<int> d_vec = h_vec;

	for (auto _ : state) {
		thrust::generate(d_vec.begin(), d_vec.end(), init_int());
	}

	//  Save statistics
	state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
	state.SetBytesProcessed(
			static_cast<int64_t>(state.iterations()) * N * sizeof(int));
	state.SetComplexityN(N);
}
BENCHMARK(thrust_generate_int)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();

struct init_cufftComplex {
	__host__ __device__
	cufftComplex operator()() {
		cufftComplex s;
		s.x = 0.0f;
		s.y = 0.0f;
		return s;
	}
};

static void thrust_generate_complex(benchmark::State& state) {
	int N = state.range(0);
	thrust::host_vector<cufftComplex> h_vec(N);

	// transfer data to the device
	thrust::device_vector<cufftComplex> d_vec = h_vec;

	for (auto _ : state) {
		thrust::generate(d_vec.begin(), d_vec.end(), init_cufftComplex());
	}

	//  Save statistics
	state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
	state.SetBytesProcessed(
			static_cast<int64_t>(state.iterations()) * N
					* sizeof(cufftComplex));
	state.SetComplexityN(N);
}
BENCHMARK(thrust_generate_complex)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();

BENCHMARK_MAIN();
