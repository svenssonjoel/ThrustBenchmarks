
RUN_ARGS?=32

ARGS=$(RUN_ARGS)

build: Scan.cu
	nvcc Scan.cu -o Scan


run: 
	./Scan $(ARGS)



clean: 
