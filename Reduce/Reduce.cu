
#include <thrust/host_vector.h> 
#include <thrust/device_vector.h> 
#include <thrust/generate.h> 
#include <thrust/reduce.h> 
#include <thrust/functional.h> 
#include <cstdlib> 

#include <stdint.h>
#include <iostream> 

#include <sys/time.h> 

int main(int argc, char **argv) { 

  struct timeval tv1,tv2; 
  
  if (argc != 2) { 
    std::cout << "Incorrect args: needs size";
    exit(-1);
  } 

  // Parse arguments 
  int size = atoi(argv[1]);
  

  //generate random vector of 32bit unsigned int 

  thrust::host_vector<uint32_t> h_vec(size);
  thrust::generate(h_vec.begin(), h_vec.end(), rand);

  // copy host to device 
  thrust::device_vector<uint32_t> d_vec = h_vec;
    
  uint32_t x;
  gettimeofday(&tv1, NULL); 
  for (int i = 0; i < 1000; ++i) { 
    x = thrust::reduce(d_vec.begin(), d_vec.end(), 0,thrust::plus<uint32_t>());
  }
  gettimeofday(&tv2, NULL); 

  std::cout << "done: " << x << "\n" ; 
  double secs = 
    (double) (tv2.tv_usec - tv1.tv_usec) /1000000 + 
    (double) (tv2.tv_sec - tv1.tv_sec); 
  std::cout << "SELFTIMED: " << secs << "\n" ;

  return 0;
}
