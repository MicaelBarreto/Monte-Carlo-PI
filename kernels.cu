#include "kernels.cuh"




__global__ void setup_kernel(curandState *worker_state)
{
	int index = threadIdx.x + blockDim.x*blockIdx.x;
    curand_init(123456789, index, 0, &worker_state[index]);
}




__global__ void monti_carlo_pi_kernel(curandState *worker_state, int *count, int m)
{
	unsigned int index = threadIdx.x + blockDim.x*blockIdx.x;

	__shared__ int cache[256];
	cache[threadIdx.x] = 0;
	__syncthreads();


	unsigned int temp = 0;
	while(temp < m){
		float x = curand_uniform(&worker_state[index]);
		float y = curand_uniform(&worker_state[index]);
		float r = x*x + y*y;

		if(r <= 1){
			cache[threadIdx.x]++;
		}
		temp++; 
	}


	// Reduction
	int i = blockDim.x/2;
	while(i != 0){
		if(threadIdx.x < i){
			cache[threadIdx.x] += cache[threadIdx.x + i];
		}

		i /= 2;
		__syncthreads();
	}


	// Update count
	if(threadIdx.x == 0){
		atomicAdd(count, cache[0]);
	}
}