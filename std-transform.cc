#include <benchmark/benchmark.h>

#include <algorithm>
#include <vector>
#include <string>
#include <cufft.h>

int op_increase_int(int i) {
  return ++i;
}

static void std_transform_int(benchmark::State& state) {
  int N = state.range(0);
  std::vector<int> vec(N);
  std::vector<int> out(N);

  for (auto _ : state) {
    std::transform(vec.begin(), vec.end(), out.begin(), op_increase_int);
  }

  //  Save statistics
  state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
  state.SetBytesProcessed(static_cast<int64_t>(state.iterations()) * N * sizeof(int));
  state.SetComplexityN(N);
}
BENCHMARK(std_transform_int)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();

cufftComplex op_increase_cufftComplex(cufftComplex s) {
  s.x++;
  s.y++;
  return s;
}

static void std_transform_complex(benchmark::State& state) {
  int N = state.range(0);
  std::vector<cufftComplex> vec(N);
  std::vector<cufftComplex> out(N);

  for (auto _ : state) {
    std::transform(vec.begin(), vec.end(), out.begin(), op_increase_cufftComplex);
  }

  //  Save statistics
  state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
  state.SetBytesProcessed(static_cast<int64_t>(state.iterations()) * N * sizeof(cufftComplex));
  state.SetComplexityN(N);
}
BENCHMARK(std_transform_complex)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();

BENCHMARK_MAIN()
;
