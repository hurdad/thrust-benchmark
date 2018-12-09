CC      = g++
NVCC	= nvcc
CFLAGS  = -std=c++11 -O2 -g -I/usr/local/cuda/targets/x86_64-linux/include/ 

LDFLAGS = -lbenchmark

all: thrust-foreach std-foreach thrust-generate std-generate


thrust-foreach : thrust-foreach.o
	$(NVCC) -o $@ $^ $(LDFLAGS)

thrust-foreach.o: thrust-foreach.cu
	$(NVCC) -c $(CFLAGS) $<
	
std-foreach: std-foreach.o
	$(CC) -o $@ $^ $(LDFLAGS)

std-foreach.o: std-foreach.cc
	$(CC) -c $(CFLAGS) $<
	
	
thrust-generate : thrust-generate.o
	$(NVCC) -o $@ $^ $(LDFLAGS)

thrust-generate.o: thrust-generate.cu
	$(NVCC) -c $(CFLAGS) $<
	
std-generate: std-generate.o
	$(CC) -o $@ $^ $(LDFLAGS)

std-generate.o: std-generate.cc
	$(CC) -c $(CFLAGS) $<
	
	
.PHONY: clean

clean:
	rm *.o thrust-foreach std-foreach thrust-generate std-generate