#include <benchmark/benchmark.h>

#include <algorithm>
#include <vector>
#include <iostream>
#include <string>

void func(int x) {
	benchmark::DoNotOptimize(x++);
}

static void std_foreach(benchmark::State& state) {
	int N = state.range(0);
	std::vector<int> vec(N);

	for (auto _ : state) {
		std::for_each(vec.begin(), vec.end(), func);
	}

	//  Save statistics
	state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
	state.SetBytesProcessed(
			static_cast<int64_t>(state.iterations()) * N * sizeof(int));
	state.SetComplexityN(N);
}
BENCHMARK(std_foreach)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();
BENCHMARK_MAIN();
