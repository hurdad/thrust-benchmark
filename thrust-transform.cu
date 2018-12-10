#include <benchmark/benchmark.h>

#include <thrust/host_vector.h>
#include <thrust/transform.h>
#include <thrust/device_vector.h>
#include <iostream>
#include <cufft.h>
#include <thrust/execution_policy.h>

struct op_increase_int {
  __host__ __device__
  bool operator()(int i) {
    return ++i;
  }
};

static void thrust_transform_int(benchmark::State& state) {
  int N = state.range(0);
  thrust::host_vector<int> h_vec(N);

  // transfer data to the device
  thrust::device_vector<int> d_vec = h_vec;
  thrust::device_vector<int> d_out(N);

  for (auto _ : state) {
    thrust::transform(d_vec.begin(), d_vec.end(), d_out.begin(), op_increase_int());
  }

  //  Save statistics
  state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
  state.SetBytesProcessed(static_cast<int64_t>(state.iterations()) * N * sizeof(int));
  state.SetComplexityN(N);
}
BENCHMARK(thrust_transform_int)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();

struct op_increase_complex {
  __host__ __device__
  cufftComplex operator()(cufftComplex s) {
    s.x++;
    s.y++;
    return s;
  }
};

static void thrust_transform_complex(benchmark::State& state) {
  int N = state.range(0);
  thrust::host_vector<cufftComplex> h_vec(N);

  // transfer data to the device
  thrust::device_vector<cufftComplex> d_vec = h_vec;
  thrust::device_vector<cufftComplex> d_out(N);

  for (auto _ : state) {
    thrust::transform(d_vec.begin(), d_vec.end(), d_out.begin(), op_increase_complex());
  }

  //  Save statistics
  state.SetItemsProcessed(static_cast<int64_t>(state.iterations()) * N);
  state.SetBytesProcessed(static_cast<int64_t>(state.iterations()) * N * sizeof(cufftComplex));
  state.SetComplexityN(N);
}
BENCHMARK(thrust_transform_complex)->RangeMultiplier(2)->Range(1<<10, 1<<26)->Complexity();

BENCHMARK_MAIN()
;
