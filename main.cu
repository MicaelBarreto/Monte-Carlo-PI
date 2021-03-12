#include <iostream>
#include "kernels.cuh"
#include <curand.h>
#include <time.h>
#include <random>
#include <math.h>




int main()
{
	int r = 128; // Radius
	int n = 20; // Threads Number
	int m = 250000; // Times 4 each Thread
	int *master_count;
	int *worker_count;
	curandState *worker_state;
	float pi;


	// Allocate variables on memory
	master_count = (int*)malloc(n*sizeof(int));
	cudaMalloc((void**)&worker_count, n*sizeof(int));
	cudaMalloc((void**)&worker_state, n*sizeof(curandState));
	cudaMemset(worker_count, 0, sizeof(int));


	// Timing
	float elapsed_time;
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);


	// Set Worker Kernel
	dim3 gridSize = r;
	dim3 blockSize = r;
	setup_kernel<<<gridSize, blockSize>>>(worker_state);


	// Start Worker Monte Carlo Kernel
	monti_carlo_pi_kernel<<<gridSize, blockSize>>>(worker_state, worker_count, m);


	// Get Results from Workers
	cudaMemcpy(master_count, worker_count, sizeof(int), cudaMemcpyDeviceToHost);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsed_time, start, stop);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);


	// Calculate && Prompt Results
	pi = *master_count*4.0/(n*m);
	std::cout<<"Monte Carlo PI Approximation calculated on GPU was "<<pi<<" and took "<<elapsed_time<<" ms to calculate "<<std::endl;


	// Free Memory
	free(master_count);
	cudaFree(worker_count);
	cudaFree(worker_state);
}
