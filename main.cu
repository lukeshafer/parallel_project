/*
 *  Parallel Implementaion of Hough Transform for Circle Detection in images
 *
 *  by Luke Shafer
 *  https://github.com/lukeshafer/parallel_project
 *
 *  nvcc shafer_project.cu -lm -lGL -lGLU -lglut
 */

#include <iostream>
#include <stdio.h>
#include <math.h>
#include <fstream>
#include "cuda_runtime.h"
#include "cuda.h"

#define XDIM 101
#define YDIM 101
#define RMAX 142

using namespace std;


__global__ void find_radius ( int *in ) {
    
    //int a = blockIdx.x;
    //int b = blockIdx.y;
}

__global__ void hough ( int *in , int *rank) {

    int x = blockIdx.x;
    int y = blockIdx.y;
    if ( in[x+XDIM*y] != 0 ) {
        for (int a = 0; a < XDIM; a++) {
            for (int b = 0; y < YDIM; y++) {
                int i = sqrt( pow(x-a,2) + pow(x-b,2) );
                rank[x+XDIM*y+XDIM*YDIM+i]++;
            }
        }
    }

}

int main( void ) {

    string input_file = "MoonOriginal.png";

    int input[XDIM][YDIM]; // test example
    int *dev_in;

    int rank[XDIM][YDIM][RMAX] = {0};
    int *dev_rank;

    //allocate GPU memory
    cudaMalloc( (void**)&dev_in, XDIM * YDIM * sizeof(int) ); 
    cudaMalloc( (void**)&dev_rank, XDIM * YDIM * RMAX * sizeof(int) ); 
    
    // Generate circle using CPU. Ideally would be replaced with actual input image
    int cx = round(XDIM/2); // center of circle
    int cy = round(YDIM/2);
    int r = 40; //value must be hard-coded

    ofstream outfile("output.csv");
    if (outfile.is_open()) {

        for (int y=0; y<XDIM; y++) {
            for (int x=0; x<YDIM; x++) {
                if ( round( sqrt( pow((x-cx),2) + pow((y-cx),2) ) ) == r ) {
                    input[x][y] = 255;
                } else {
                    input[x][y] = 0;
                }
                outfile << input[x][y] << ",";
            }
            outfile << "\n";
        }
        outfile.close();
    } else printf("Unable to open file");

    // At this point, we have our circle image as a 2d array of integers
    
    // copy input to GPU memory
    cudaMemcpy( dev_in, input, XDIM * YDIM * sizeof(int),
                              cudaMemcpyHostToDevice );
    cudaMemcpy( dev_rank, rank, XDIM * YDIM * RMAX * sizeof(int),
                              cudaMemcpyHostToDevice );

    

    dim3    grid(XDIM,YDIM);
    hough<<<grid,1>>>(dev_in, dev_rank);

    cudaFree( dev_in );
    cudaFree( dev_rank );

    return 0;
}
