
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
  struct timeval trans_t1, trans_t2;
  
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
  gettimeofday(&trans_t1, NULL); 
  thrust::device_vector<uint32_t> d_vec = h_vec;
  gettimeofday(&trans_t2, NULL); 

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

  double trans_secs =    
    (double) (trans_t2.tv_usec - trans_t1.tv_usec) /1000000 + 
    (double) (trans_t2.tv_sec - trans_t1.tv_sec); 

  
  std::cout << "ELEMENTS_PROCESSED: " << size << "\n" ; 
  std::cout << "SELFTIMED: " << secs << "\n" ;
  std::cout << "TRANSFER_TO_DEVICE: " << trans_secs << "\n";
  std::cout << "BYTES_TO_DEVICE: " << size * sizeof(uint32_t) << "\n";
  std::cout << "BYTES_FROM_DEVICE: " << 1 * sizeof(uint32_t) << "\n";


  return 0;
}
