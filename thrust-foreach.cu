#include <benchmark/benchmark.h>

#include <thrust/host_vector.h>
#include <thrust/for_each.h>
#include <thrust/device_vector.h>
#include <iostream>

struct func {
  __host__ __device__
  void operator()(int x) {
    x++;
  }
};

static void thrust_foreach(benchmark::State& state) {
  int N = state.range(0);
  thrust::host_vector<int> h_vec(N);

  // transfer data to the device
  thrust::device_vector<int> d_vec = h_vec;

  for (auto _ : state) {
    thrust::for_each(d_vec.begin(), d_vec.end(), func());
  }

  //  Save statistics
  state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
  state.SetBytesProcessed(static_cast<int64_t>(state.iterations()) * N * sizeof(int));
  state.SetComplexityN(N);
}
BENCHMARK(thrust_foreach)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();
BENCHMARK_MAIN();
