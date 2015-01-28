
RUN_ARGS?=32

ARGS=$(RUN_ARGS)

build: Sort.cu
	nvcc Sort.cu -o Sort


run: 
	./Scan $(ARGS)



clean: 
