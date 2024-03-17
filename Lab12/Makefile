CFLAGS = -Wall -g -O2
CXX = g++
LIBS = -lm

all: filter transpose

init_filter.o: init_filter.cpp filter.h
	$(CXX) $(CFLAGS) -c init_filter.cpp

filter.o: filter.cpp filter.h
	$(CXX) $(CFLAGS) -c filter.cpp

main-filter.o: main-filter.cpp filter.h
	$(CXX) $(CFLAGS) -c main-filter.cpp

filter: main-filter.o filter.o init_filter.o
	$(CXX) $(CFLAGS) main-filter.o filter.o init_filter.o -o filter

main-transpose.o: main-transpose.cpp transpose.h
	$(CXX) $(CFLAGS) -c main-transpose.cpp

transpose.o: transpose.cpp transpose.h
	$(CXX) $(CFLAGS) -c transpose.cpp

transpose: main-transpose.o transpose.o
	$(CXX) $(CFLAGS) main-transpose.o transpose.o -o transpose


clean:
	rm -f *.o *.exe filter transpose
