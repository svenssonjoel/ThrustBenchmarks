
RUN_ARGS?=32

ARGS=$(RUN_ARGS)

build: Reduce.cu
	nvcc Reduce.cu -o Reduce


run: 
	./Reduce $(ARGS)



clean: 
