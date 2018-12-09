#include <benchmark/benchmark.h>

#include <algorithm>
#include <vector>
#include <iostream>
#include <string>
#include <cufft.h>

int initInt(){
	return 1;
}

static void std_generate_int(benchmark::State& state) {
	int N = state.range(0);
	std::vector<int> vec(N);

	for (auto _ : state) {
		std::generate(vec.begin(), vec.end(), initInt);
	}

	//  Save statistics
	state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
	state.SetBytesProcessed(
			static_cast<int64_t>(state.iterations()) * N * sizeof(int));
	state.SetComplexityN(N);
}
BENCHMARK(std_generate_int)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();

cufftComplex initcufftComplex() {
	cufftComplex s ;
	s.x = 0.0f;
	s.y = 0.0f;
	return s;
}

static void std_generate_complex(benchmark::State& state) {
	int N = state.range(0);
	std::vector<cufftComplex> vec(N);

	for (auto _ : state) {
		std::generate(vec.begin(), vec.end(), initcufftComplex);
	}

	//  Save statistics
	state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
	state.SetBytesProcessed(
			static_cast<int64_t>(state.iterations()) * N * sizeof(cufftComplex));
	state.SetComplexityN(N);
}
BENCHMARK(std_generate_complex)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();

BENCHMARK_MAIN()
;
